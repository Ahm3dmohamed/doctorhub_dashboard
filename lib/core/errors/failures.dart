import 'package:equatable/equatable.dart';

/// DoctorHub — Base Failure Classes (Clean Architecture)
/// All errors in the domain layer are represented as typed Failures
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

// ─── Network Failures ─────────────────────────────────────────────────────────

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection. Please check your network.', super.code});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'The request timed out. Please try again.', super.code});
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

// ─── Auth Failures ────────────────────────────────────────────────────────────

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password. Please try again.',
    super.code = 'INVALID_CREDENTIALS',
  });
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure({
    super.message = 'Your session has expired. Please sign in again.',
    super.code = 'UNAUTHORIZED',
  });
}

class AccountLockedFailure extends AuthFailure {
  const AccountLockedFailure({
    super.message = 'Your account has been locked. Please contact support.',
    super.code = 'ACCOUNT_LOCKED',
  });
}

class EmailNotFoundFailure extends AuthFailure {
  const EmailNotFoundFailure({
    super.message = 'No account found with this email address.',
    super.code = 'EMAIL_NOT_FOUND',
  });
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure({
    super.message = 'Your reset link has expired. Please request a new one.',
    super.code = 'TOKEN_EXPIRED',
  });
}

// ─── Validation Failures ──────────────────────────────────────────────────────

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

// ─── Cache Failures ───────────────────────────────────────────────────────────

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to read or write local data.',
    super.code = 'CACHE_ERROR',
  });
}

// ─── Not Found ────────────────────────────────────────────────────────────────

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code = 'NOT_FOUND',
  });
}

// ─── Unexpected ───────────────────────────────────────────────────────────────

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNEXPECTED',
  });
}
