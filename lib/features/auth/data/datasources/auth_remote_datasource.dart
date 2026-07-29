import 'dart:math';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Auth Remote DataSource — Mock Implementation
/// Simulates a real API with realistic delays and error scenarios.
/// Replace with real Dio calls for production.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<String> forgotPassword({required String email});

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<bool> logout({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // ─── Mock User Database ───────────────────────────────────────────────────
  static final Map<String, _MockUser> _mockUsers = {
    'admin@doctorhub.com': _MockUser(
      id: 'usr_001',
      name: 'Dr. Alex Morgan',
      email: 'admin@doctorhub.com',
      password: 'Admin@123',
      role: UserRole.superAdmin,
      avatarUrl: null,
    ),
    'doctor@doctorhub.com': _MockUser(
      id: 'usr_002',
      name: 'Dr. Sarah Johnson',
      email: 'doctor@doctorhub.com',
      password: 'Doctor@123',
      role: UserRole.doctor,
      specialty: 'Cardiology',
      avatarUrl: null,
    ),
    'manager@doctorhub.com': _MockUser(
      id: 'usr_003',
      name: 'Alex Turner',
      email: 'manager@doctorhub.com',
      password: 'Manager@123',
      role: UserRole.clinicManager,
      clinicId: 'clinic_001',
      avatarUrl: null,
    ),
  };

  static final Map<String, String> _resetTokens = {};

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(AppConstants.mockApiDelay);

    final normalizedEmail = email.trim().toLowerCase();
    final mockUser = _mockUsers[normalizedEmail];

    if (mockUser == null) {
      throw const InvalidCredentialsException();
    }

    if (mockUser.password != password) {
      throw const InvalidCredentialsException();
    }

    if (!mockUser.isActive) {
      throw const AccountLockedException();
    }

    return UserModel(
      id: mockUser.id,
      name: mockUser.name,
      email: mockUser.email,
      role: mockUser.role,
      token: _generateToken(),
      avatarUrl: mockUser.avatarUrl,
      specialty: mockUser.specialty,
      clinicId: mockUser.clinicId,
      lastLoginAt: DateTime.now(),
      isActive: mockUser.isActive,
    );
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    await Future.delayed(AppConstants.mockApiDelay);

    final normalizedEmail = email.trim().toLowerCase();

    if (!_mockUsers.containsKey(normalizedEmail)) {
      throw const EmailNotFoundException();
    }

    // Generate and store reset token
    final token = _generateResetToken();
    _resetTokens[normalizedEmail] = token;

    // In production this would send an email
    // For development, we'll log the token
    assert(() {
      // ignore: avoid_print
      print('[DoctorHub Mock] Password reset token for $normalizedEmail: $token');
      return true;
    }());

    return 'Password reset instructions sent to $normalizedEmail';
  }

  @override
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(AppConstants.mockApiDelay);

    // For demo, accept any 6+ character token
    if (token.trim().length < 6) {
      throw const TokenExpiredException();
    }

    return true;
  }

  @override
  Future<bool> logout({required String token}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────
  String _generateToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(64, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String _generateResetToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}

class _MockUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? avatarUrl;
  final String? specialty;
  final String? clinicId;
  final bool isActive = true;

  const _MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.avatarUrl,
    this.specialty,
    this.clinicId,
  });
}
