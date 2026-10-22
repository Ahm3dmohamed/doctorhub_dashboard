import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// DoctorHub — Supabase Storage Service
/// Provides unified file uploading and retrieval for both Flutter Mobile and Flutter Web.
class SupabaseStorageService {
  final SupabaseClient? _client;

  SupabaseStorageService([SupabaseClient? client]) : _client = client;

  SupabaseClient get _activeClient =>
      _client ??
      (SupabaseConfig.isInitialized
          ? SupabaseConfig.client
          : Supabase.instance.client);

  /// Maximum file size allowed for uploads (5 MB).
  static const int maxFileSizeInBytes = 5 * 1024 * 1024;

  /// Upload a user or doctor avatar to the public avatars bucket.
  /// Returns the public URL of the uploaded image.
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? mimeType,
  }) async {
    _validateFileSize(bytes);

    final cleanExt = fileExtension.replaceAll('.', '').toLowerCase();
    final fileName =
        '$userId/${DateTime.now().millisecondsSinceEpoch}.$cleanExt';

    await _activeClient.storage
        .from(SupabaseConfig.avatarsBucket)
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: mimeType ?? _guessMimeType(cleanExt),
            upsert: true,
          ),
        );

    return _activeClient.storage
        .from(SupabaseConfig.avatarsBucket)
        .getPublicUrl(fileName);
  }

  /// Upload an image to the clinic gallery bucket.
  Future<String> uploadClinicGalleryImage({
    required String clinicId,
    required Uint8List bytes,
    required String fileExtension,
    String? mimeType,
  }) async {
    _validateFileSize(bytes);

    final cleanExt = fileExtension.replaceAll('.', '').toLowerCase();
    final fileName =
        '$clinicId/${DateTime.now().millisecondsSinceEpoch}.$cleanExt';

    await _activeClient.storage
        .from(SupabaseConfig.clinicGalleriesBucket)
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: mimeType ?? _guessMimeType(cleanExt),
            upsert: false,
          ),
        );

    return _activeClient.storage
        .from(SupabaseConfig.clinicGalleriesBucket)
        .getPublicUrl(fileName);
  }

  /// Upload a private medical document or attachment.
  /// Stored in a private bucket. Returns the object storage path.
  Future<String> uploadMedicalDocument({
    required String patientId,
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
  }) async {
    _validateFileSize(bytes);

    final cleanName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final storagePath =
        '$patientId/${DateTime.now().millisecondsSinceEpoch}_$cleanName';

    await _activeClient.storage
        .from(SupabaseConfig.documentsBucket)
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: FileOptions(contentType: mimeType, upsert: false),
        );

    return storagePath;
  }

  /// Create a time-limited signed URL for private medical documents.
  Future<String> getSignedUrlForDocument({
    required String storagePath,
    int expiresInSeconds = 3600,
  }) async {
    return await _activeClient.storage
        .from(SupabaseConfig.documentsBucket)
        .createSignedUrl(storagePath, expiresInSeconds);
  }

  /// Delete a file from any bucket.
  Future<void> deleteFile({
    required String bucketName,
    required String path,
  }) async {
    await _activeClient.storage.from(bucketName).remove([path]);
  }

  void _validateFileSize(Uint8List bytes) {
    if (bytes.lengthInBytes > maxFileSizeInBytes) {
      throw const FormatException(
        'File size exceeds the 5 MB limit. Please select a smaller file.',
      );
    }
  }

  String _guessMimeType(String ext) {
    return switch (ext.toLowerCase()) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'pdf' => 'application/pdf',
      _ => 'application/octet-stream',
    };
  }
}
