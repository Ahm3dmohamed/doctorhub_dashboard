import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart' as app_ex;
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Auth Remote DataSource Interface
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<String> forgotPassword({required String email});

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<bool> logout({required String token});

  /// Fetch user profile from Supabase by UID
  Future<UserModel?> getUserProfile(String userId, {String? token});
}

/// Unified Auth Remote DataSource
/// Connects to Supabase Auth when configured, with seamless fallback
/// to demo mock users for offline / preliminary development.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // ─── Mock Fallback Users ──────────────────────────────────────────────────
  static final Map<String, _MockUser> _mockUsers = {
    'admin@doctorhub.com': const _MockUser(
      id: 'usr_001',
      name: 'Dr. Alex Morgan',
      email: 'admin@doctorhub.com',
      password: 'Admin@123',
      role: UserRole.superAdmin,
      avatarUrl: null,
    ),
    'doctor@doctorhub.com': const _MockUser(
      id: 'usr_002',
      name: 'Dr. Sarah Johnson',
      email: 'doctor@doctorhub.com',
      password: 'Doctor@123',
      role: UserRole.doctor,
      specialty: 'Cardiology',
      avatarUrl: null,
    ),
    'manager@doctorhub.com': const _MockUser(
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
    final normalizedEmail = email.trim().toLowerCase();

    // ── 1. Supabase Auth if initialized ──────────────────────────────────────
    if (SupabaseConfig.isInitialized) {
      try {
        final client = SupabaseConfig.client;
        final authResponse = await client.auth.signInWithPassword(
          email: normalizedEmail,
          password: password,
        );

        final user = authResponse.user;
        if (user == null) {
          throw const app_ex.InvalidCredentialsException();
        }

        final accessToken = authResponse.session?.accessToken ?? '';

        // Query profile from Supabase PostgreSQL `profiles` table
        final profileResponse = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (profileResponse != null) {
          return UserModel.fromSupabase(profileResponse, token: accessToken);
        }

        // Fallback: profile does not exist yet -> synthesize from user metadata
        final metadata = user.userMetadata ?? {};
        final userModel = UserModel(
          id: user.id,
          name:
              (metadata['name'] as String?) ??
              user.email?.split('@').first ??
              'DoctorHub User',
          email: user.email ?? normalizedEmail,
          role: _parseUserRole(metadata['role'] as String?),
          token: accessToken,
          avatarUrl: metadata['avatar_url'] as String?,
          specialty: metadata['specialty'] as String?,
          clinicId: metadata['clinic_id'] as String?,
          lastLoginAt: DateTime.now(),
          isActive: true,
        );

        // Auto-create initial profile row
        try {
          await client.from('profiles').upsert(userModel.toSupabaseMap());
        } catch (_) {
          // Silently ignore if RLS restricts client upsert
        }

        return userModel;
      } on AuthException catch (e) {
        final msg = e.message.toLowerCase();
        if (msg.contains('invalid login credentials') ||
            msg.contains('invalid email or password') ||
            msg.contains('user not found')) {
          throw const app_ex.InvalidCredentialsException();
        }
        if (msg.contains('email not confirmed')) {
          throw const app_ex.AuthException(
            message: 'Please confirm your email address before signing in.',
            code: 'EMAIL_NOT_CONFIRMED',
          );
        }
        throw app_ex.AppException(message: e.message);
      } catch (e) {
        if (e is app_ex.AppException) rethrow;
        throw app_ex.AppException(message: e.toString());
      }
    }

    // ── 2. Mock Fallback when Supabase credentials not provided ──────────────
    await Future.delayed(AppConstants.mockApiDelay);

    final mockUser = _mockUsers[normalizedEmail];
    if (mockUser == null || mockUser.password != password) {
      throw const app_ex.InvalidCredentialsException();
    }

    if (!mockUser.isActive) {
      throw const app_ex.AccountLockedException();
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
    final normalizedEmail = email.trim().toLowerCase();

    if (SupabaseConfig.isInitialized) {
      try {
        final client = SupabaseConfig.client;
        await client.auth.resetPasswordForEmail(normalizedEmail);
        return 'Password reset link sent to $normalizedEmail';
      } on AuthException catch (e) {
        throw app_ex.AppException(message: e.message);
      } catch (e) {
        throw app_ex.AppException(message: e.toString());
      }
    }

    await Future.delayed(AppConstants.mockApiDelay);

    if (!_mockUsers.containsKey(normalizedEmail)) {
      throw const app_ex.EmailNotFoundException();
    }

    final token = _generateResetToken();
    _resetTokens[normalizedEmail] = token;

    return 'Password reset instructions sent to $normalizedEmail';
  }

  @override
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (SupabaseConfig.isInitialized) {
      try {
        final client = SupabaseConfig.client;
        await client.auth.updateUser(UserAttributes(password: newPassword));
        return true;
      } on AuthException catch (e) {
        throw app_ex.AppException(message: e.message);
      } catch (e) {
        throw app_ex.AppException(message: e.toString());
      }
    }

    await Future.delayed(AppConstants.mockApiDelay);

    if (token.trim().length < 6) {
      throw const app_ex.TokenExpiredException();
    }

    return true;
  }

  @override
  Future<bool> logout({required String token}) async {
    if (SupabaseConfig.isInitialized) {
      try {
        await SupabaseConfig.client.auth.signOut();
      } catch (_) {}
      return true;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<UserModel?> getUserProfile(String userId, {String? token}) async {
    if (!SupabaseConfig.isInitialized) return null;

    try {
      final client = SupabaseConfig.client;
      final profile = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (profile != null) {
        return UserModel.fromSupabase(profile, token: token);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────
  String _generateToken() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(64, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String _generateResetToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}

UserRole _parseUserRole(String? role) {
  return switch (role?.toLowerCase()) {
    'superadmin' || 'super_admin' => UserRole.superAdmin,
    'doctor' => UserRole.doctor,
    'clinicmanager' || 'clinic_manager' => UserRole.clinicManager,
    _ => UserRole.doctor,
  };
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
