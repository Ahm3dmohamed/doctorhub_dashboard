import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'failures.dart';

/// DoctorHub — Supabase Error Handler
/// Converts Supabase SDK exceptions into domain-layer [Failure] objects.
/// Ensures internal technical details, raw database schemas, and stack traces
/// are not leaked directly to the user interface.
abstract class SupabaseErrorHandler {
  static Failure handle(dynamic error) {
    if (error is AuthException) {
      return _handleAuthException(error);
    }

    if (error is PostgrestException) {
      return _handlePostgrestException(error);
    }

    if (error is StorageException) {
      return _handleStorageException(error);
    }

    if (error is SocketException) {
      return const NetworkFailure(
        message:
            'Unable to connect to the server. Please check your internet connection.',
      );
    }

    return UnexpectedFailure(
      message: error is Exception
          ? error.toString()
          : 'An unexpected error occurred.',
    );
  }

  static Failure _handleAuthException(AuthException e) {
    final msg = e.message.toLowerCase();

    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid email or password') ||
        msg.contains('user not found')) {
      return const InvalidCredentialsFailure();
    }

    if (msg.contains('email not confirmed')) {
      return const AuthFailure(
        message: 'Please verify your email address before signing in.',
        code: 'EMAIL_NOT_CONFIRMED',
      );
    }

    if (msg.contains('user already registered') ||
        msg.contains('already exists')) {
      return const AuthFailure(
        message: 'An account with this email address already exists.',
        code: 'USER_ALREADY_EXISTS',
      );
    }

    if (msg.contains('token has expired') || msg.contains('otp expired')) {
      return const TokenExpiredFailure();
    }

    if (msg.contains('too many requests') || msg.contains('rate limit')) {
      return const AuthFailure(
        message: 'Too many attempts. Please wait a moment and try again.',
        code: 'RATE_LIMITED',
      );
    }

    return AuthFailure(message: e.message, code: e.statusCode);
  }

  static Failure _handlePostgrestException(PostgrestException e) {
    // 42501: Row-Level Security permission violation
    if (e.code == '42501') {
      return const UnauthorizedFailure(
        message: 'You do not have permission to perform this action.',
      );
    }

    // 23505: Unique violation
    if (e.code == '23505') {
      return const ValidationFailure(
        message: 'A record with these details already exists.',
      );
    }

    // 23503: Foreign key violation
    if (e.code == '23503') {
      return const ValidationFailure(
        message: 'Referenced entity does not exist.',
      );
    }

    // PGRST116: No row returned for single query
    if (e.code == 'PGRST116') {
      return const NotFoundFailure(
        message: 'The requested resource was not found.',
      );
    }

    return ServerFailure(
      message: 'Database operation failed. Please try again.',
      code: e.code,
    );
  }

  static Failure _handleStorageException(StorageException e) {
    if (e.statusCode == '403') {
      return const UnauthorizedFailure(
        message: 'You do not have permission to access or upload this file.',
      );
    }

    if (e.statusCode == '404') {
      return const NotFoundFailure(
        message: 'The requested file could not be found.',
      );
    }

    if (e.statusCode == '413') {
      return const ValidationFailure(
        message: 'The selected file exceeds the maximum allowed upload size.',
      );
    }

    return ServerFailure(
      message: 'Storage operation failed. Please try again.',
      code: e.statusCode,
    );
  }
}
