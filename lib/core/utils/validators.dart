import 'package:doctorhub_dashboard/l10n/app_localizations.dart';

/// DoctorHub — Form Validators with AppLocalizations support
class Validators {
  Validators._();

  // ─── Email ────────────────────────────────────────────────────────────────
  static String? email(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.trim().isEmpty) {
      return l10n?.valRequired ?? 'Email address is required';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return l10n?.valInvalidEmail ?? 'Enter a valid email address';
    }
    return null;
  }

  // ─── Password ─────────────────────────────────────────────────────────────
  static String? password(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.valRequired ?? 'Password is required';
    }
    if (value.length < 8) {
      return l10n?.valPasswordLength ??
          'Password must be at least 8 characters';
    }
    return null;
  }

  /// Simpler password validator for login
  static String? loginPassword(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.valRequired ?? 'Password is required';
    }
    if (value.length < 6) {
      return l10n?.valPasswordLength ??
          'Password must be at least 6 characters';
    }
    return null;
  }

  // ─── Confirm Password ─────────────────────────────────────────────────────
  static String? Function(String?) confirmPassword(
    String originalPassword, [
    AppLocalizations? l10n,
  ]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n?.valRequired ?? 'Please confirm your password';
      }
      if (value != originalPassword) {
        return l10n?.valPasswordMismatch ?? 'Passwords do not match';
      }
      return null;
    };
  }

  // ─── Required ─────────────────────────────────────────────────────────────
  static String? required(
    String? value, {
    String? fieldName,
    AppLocalizations? l10n,
  }) {
    if (value == null || value.trim().isEmpty) {
      if (fieldName != null) {
        return '$fieldName ${l10n?.valRequired ?? 'is required'}';
      }
      return l10n?.valRequired ?? 'This field is required';
    }
    return null;
  }

  // ─── Phone ────────────────────────────────────────────────────────────────
  static String? phone(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.trim().isEmpty) {
      return l10n?.valRequired ?? 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (!RegExp(r'^\d{7,15}$').hasMatch(cleaned)) {
      return l10n?.valInvalidPhone ?? 'Enter a valid phone number';
    }
    return null;
  }

  // ─── Reset Token ──────────────────────────────────────────────────────────
  static String? resetToken(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.trim().isEmpty) {
      return l10n?.valRequired ?? 'Reset code is required';
    }
    if (value.trim().length < 6) {
      return l10n?.valInvalidToken ?? 'Enter the 6-character reset code';
    }
    return null;
  }

  // ─── Compose validators ───────────────────────────────────────────────────
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
