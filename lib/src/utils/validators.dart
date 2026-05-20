import 'package:easy_localization/easy_localization.dart';

/// Centralized form validation logic.
abstract final class Validators {
  Validators._();

  /// Validates that the input is a correctly formatted email.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.email_required'.tr();
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'auth.email_invalid'.tr();
    }

    return null;
  }

  /// Validates password strength (minimum 6 characters).
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.password_required'.tr();
    }
    if (value.length < 6) {
      return 'auth.password_too_short'.tr();
    }
    return null;
  }

  /// Validates a name (not empty).
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.name_required'.tr();
    }
    return null;
  }

  /// Validates an Egyptian phone number (11 digits).
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.phone_required'.tr();
    }

    final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'auth.phone_invalid'.tr();
    }

    return null;
  }
}
