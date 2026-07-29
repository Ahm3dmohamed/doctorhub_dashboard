import 'dart:convert';
import '../../domain/entities/user_entity.dart';

/// UserModel — Data layer representation of a User
/// Extends UserEntity with JSON serialization
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.token,
    super.avatarUrl,
    super.specialty,
    super.clinicId,
    super.lastLoginAt,
    super.isActive,
  });

  /// Create from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: _parseRole(json['role'] as String?),
      token: json['token'] as String,
      avatarUrl: json['avatar_url'] as String?,
      specialty: json['specialty'] as String?,
      clinicId: json['clinic_id'] as String?,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Convert to JSON (for caching)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
        'token': token,
        'avatar_url': avatarUrl,
        'specialty': specialty,
        'clinic_id': clinicId,
        'last_login_at': lastLoginAt?.toIso8601String(),
        'is_active': isActive,
      };

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String jsonString) =>
      UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  /// Create from domain entity
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        role: entity.role,
        token: entity.token,
        avatarUrl: entity.avatarUrl,
        specialty: entity.specialty,
        clinicId: entity.clinicId,
        lastLoginAt: entity.lastLoginAt,
        isActive: entity.isActive,
      );

  static UserRole _parseRole(String? role) {
    return switch (role?.toLowerCase()) {
      'superadmin' || 'super_admin' => UserRole.superAdmin,
      'doctor' => UserRole.doctor,
      'clinicmanager' || 'clinic_manager' => UserRole.clinicManager,
      _ => UserRole.doctor,
    };
  }
}
