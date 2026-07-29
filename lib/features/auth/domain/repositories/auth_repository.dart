import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Auth Repository Contract (Domain Layer Interface)
abstract class AuthRepository {
  /// Authenticate user with email and password.
  /// Returns [UserEntity] on success or [Failure] on error.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Send password reset email.
  Future<Either<Failure, String>> forgotPassword({required String email});

  /// Reset password using token received via email.
  Future<Either<Failure, bool>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Sign out the current user and clear local session.
  Future<Either<Failure, bool>> logout();

  /// Get cached user session (from SharedPreferences).
  Future<Either<Failure, UserEntity?>> getCachedUser();

  /// Check if user session is still valid.
  Future<Either<Failure, bool>> isAuthenticated();
}
