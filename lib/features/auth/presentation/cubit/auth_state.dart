import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Authentication State sealed class hierarchy
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — before any auth check
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Checking stored session / performing auth action
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is fully authenticated
final class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An auth operation failed
final class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Forgot password email sent successfully
final class AuthForgotPasswordSent extends AuthState {
  final String email;
  final String message;

  const AuthForgotPasswordSent({required this.email, required this.message});

  @override
  List<Object?> get props => [email, message];
}

/// Password has been reset successfully
final class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}
