library;

/// DoctorHub — Exception Classes (Data Layer)
/// Exceptions are thrown in the data layer and caught to produce Failures

class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Network Exceptions ───────────────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection.',
    super.code = 'NETWORK_ERROR',
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out.',
    super.code = 'TIMEOUT',
  });
}

class ServerException extends AppException {
  final int statusCode;

  const ServerException({
    required super.message,
    required this.statusCode,
    super.code,
  });

  @override
  String toString() => 'ServerException($statusCode): $message';
}

// ─── Auth Exceptions ──────────────────────────────────────────────────────────

class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    super.message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
  });
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Session expired. Please sign in again.',
    super.code = 'UNAUTHORIZED',
  });
}

class AccountLockedException extends AuthException {
  const AccountLockedException({
    super.message = 'Account has been locked.',
    super.code = 'ACCOUNT_LOCKED',
  });
}

class EmailNotFoundException extends AuthException {
  const EmailNotFoundException({
    super.message = 'Email not found.',
    super.code = 'EMAIL_NOT_FOUND',
  });
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Reset token has expired.',
    super.code = 'TOKEN_EXPIRED',
  });
}

// ─── Cache Exceptions ─────────────────────────────────────────────────────────

class CacheException extends AppException {
  const CacheException({
    super.message = 'Local cache error.',
    super.code = 'CACHE_ERROR',
  });
}

// ─── Validation Exceptions ────────────────────────────────────────────────────

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });
}
