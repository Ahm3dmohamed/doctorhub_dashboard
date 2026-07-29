import 'package:equatable/equatable.dart';

/// User roles in the DoctorHub system
enum UserRole {
  superAdmin,
  doctor,
  clinicManager;

  String get displayName => switch (this) {
        UserRole.superAdmin => 'Super Admin',
        UserRole.doctor => 'Doctor',
        UserRole.clinicManager => 'Clinic Manager',
      };

  String get emoji => switch (this) {
        UserRole.superAdmin => '👑',
        UserRole.doctor => '🩺',
        UserRole.clinicManager => '🏥',
      };

  bool get canAccessAdmin => this == UserRole.superAdmin;
  bool get canManagePatients => this == UserRole.doctor || this == UserRole.superAdmin;
  bool get canManageClinics =>
      this == UserRole.clinicManager || this == UserRole.superAdmin;
}

/// Core User domain entity
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String token;
  final String? avatarUrl;
  final String? specialty;     // For doctors
  final String? clinicId;      // For clinic managers
  final DateTime? lastLoginAt;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.avatarUrl,
    this.specialty,
    this.clinicId,
    this.lastLoginAt,
    this.isActive = true,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? token,
    String? avatarUrl,
    String? specialty,
    String? clinicId,
    DateTime? lastLoginAt,
    bool? isActive,
  }) =>
      UserEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        token: token ?? this.token,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        specialty: specialty ?? this.specialty,
        clinicId: clinicId ?? this.clinicId,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        isActive: isActive ?? this.isActive,
      );

  @override
  List<Object?> get props => [id, name, email, role, token, isActive];
}
