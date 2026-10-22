import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// DoctorHub — Supabase Configuration and Startup Handler.
///
/// Handles environment variable extraction via `--dart-define`,
/// secure initialization for Flutter Mobile & Flutter Web,
/// and fallback detection for development/offline environments.
abstract class SupabaseConfig {
  /// Supabase Project URL provided via compile-time environment variable:
  /// `--dart-define=SUPABASE_URL=https://xyzcompany.supabase.co`
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Supabase Publishable / Anon Key provided via compile-time environment variable:
  /// `--dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...`
  ///
  /// IMPORTANT: Only publishable anon keys should be passed to client applications.
  /// Never expose the service_role key to Flutter Mobile or Web.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // ─── Storage Bucket Names ──────────────────────────────────────────────────
  static const String avatarsBucket = 'doctorhub-avatars';
  static const String clinicGalleriesBucket = 'doctorhub-clinic-galleries';
  static const String documentsBucket = 'doctorhub-documents';

  /// Whether Supabase credentials have been configured and are valid.
  static bool get isConfigured {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(supabaseUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return false;
    }
    // Check if placeholder values were left unchanged
    if (supabaseUrl.contains('your-project') ||
        supabaseAnonKey.contains('your-anon-key')) {
      return false;
    }
    return true;
  }

  /// Flag indicating whether the Supabase client was successfully initialized.
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  /// Get the active SupabaseClient instance.
  /// Throws [StateError] if Supabase has not been initialized.
  static SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError(
        'Supabase has not been initialized. Check SupabaseConfig.isConfigured first.',
      );
    }
    return Supabase.instance.client;
  }

  /// Initialize Supabase Flutter SDK.
  ///
  /// This must be called inside `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
  /// If credentials are missing or invalid, it returns `false` gracefully without throwing,
  /// allowing development and testing to fall back safely without crashing.
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    if (!isConfigured) {
      if (kDebugMode) {
        debugPrint(
          '[DoctorHub] Running in Development Mode (Mock Data Active).\n'
          '[DoctorHub] To connect to a live Supabase project, add your keys in supabase_env.json and run:\n'
          '  flutter run --dart-define-from-file=supabase_env.json\n'
          '  or launch "DoctorHub (Supabase Live)" from VS Code / IDE.',
        );
      }
      return false;
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey, // ignore: deprecated_member_use
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint(
          '[DoctorHub Supabase] Successfully initialized client for $supabaseUrl',
        );
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[DoctorHub Supabase] Initialization failed: $e');
      }
      _isInitialized = false;
      return false;
    }
  }
}
