/// DoctorHub — Exception Classes (Data Layer)
///
/// All exceptions are thrown exclusively in the data layer and converted
/// into [Failure] objects at repository boundaries. Do NOT use exceptions
/// in the domain or presentation layers.
library;

// ─── Base Exception ────────────────────────────────────────────────────────────

/// Base class for all DoctorHub data-layer exceptions.
class AppException implements Exception {
  /// Human-readable description of what went wrong.
  final String message;

  /// Optional machine-readable error code (e.g. `'NOT_FOUND'`).
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Network Exceptions ────────────────────────────────────────────────────────

/// Thrown when the device has no internet connectivity.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Thrown when a request exceeds its allowed duration.
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out.',
    super.code = 'TIMEOUT',
  });
}

/// Thrown when the server returns a non-2xx HTTP response.
class ServerException extends AppException {
  /// The HTTP status code returned by the server.
  final int? statusCode;

  const ServerException({
    required super.message,
    this.statusCode,
    super.code,
  });

  @override
  String toString() => 'ServerException($statusCode): $message';
}

// ─── Auth Exceptions ───────────────────────────────────────────────────────────

/// Base class for all authentication-related exceptions.
class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

/// Thrown when the provided email/password pair is incorrect.
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    super.message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
  });
}

/// Thrown when the user's session token is expired or missing.
class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Session expired. Please sign in again.',
    super.code = 'UNAUTHORIZED',
  });
}

/// Thrown when the account has been locked due to too many failed attempts.
class AccountLockedException extends AuthException {
  const AccountLockedException({
    super.message = 'Account has been locked.',
    super.code = 'ACCOUNT_LOCKED',
  });
}

/// Thrown when no account exists for the given email address.
class EmailNotFoundException extends AuthException {
  const EmailNotFoundException({
    super.message = 'Email not found.',
    super.code = 'EMAIL_NOT_FOUND',
  });
}

/// Thrown when a password-reset token has expired.
class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Reset token has expired.',
    super.code = 'TOKEN_EXPIRED',
  });
}

// ─── Cache Exceptions ──────────────────────────────────────────────────────────

/// Thrown when local storage read/write operations fail.
class CacheException extends AppException {
  const CacheException({
    super.message = 'Local cache error.',
    super.code = 'CACHE_ERROR',
  });
}

// ─── Validation Exceptions ─────────────────────────────────────────────────────

/// Thrown when request payload fails business-rule validation.
class ValidationException extends AppException {
  /// Field-level error messages keyed by field name.
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });
}
