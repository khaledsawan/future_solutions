import 'package:easy_localization/easy_localization.dart';
import 'package:future_solutions/core/error/failure.dart';

/// Service for localizing error messages.
///
/// Provides methods to get localized error messages from Failure objects.
/// Message resolution priority:
/// 1. Server-provided message (for ServerFailure with dynamic message)
/// 2. Localized message from key
/// 3. Fallback to hardcoded message
class ErrorLocalizationService {
  /// Gets the localized error message for a Failure.
  ///
  /// Returns the message in the following priority:
  /// 1. If ServerFailure has a server-provided message, use it (may already be localized by backend)
  /// 2. If Failure has a localization key, get localized message using easy_localization
  /// 3. Fallback to the hardcoded message from Failure class
  static String getLocalizedMessage(Failure failure) {
    // For ServerFailure, prioritize server message if it's meaningful
    if (failure is ServerFailure) {
      // Use server message if available and not a generic error
      final serverMessage = failure.message;
      if (serverMessage.isNotEmpty &&
          serverMessage != 'Server error' &&
          serverMessage != 'Unexpected server error') {
        return serverMessage;
      }
    }

    // Try to get localized message from key
    final key = failure.errorKey;
    if (key != null) {
      try {
        final localized = key.tr();
        // If translation exists (not the same as key), use it
        if (localized != key) {
          return localized;
        }
      } catch (e) {
        // Key doesn't exist in translations, fall through to message
      }
    }

    // Fallback to hardcoded message
    return failure.message;
  }

  /// Gets the localization key for a Failure.
  ///
  /// Returns the localization key that can be used with easy_localization
  /// or null if no key is available.
  static String? getErrorMessageKey(Failure failure) {
    return failure.errorKey;
  }

  /// Gets localized message with optional code interpolation.
  ///
  /// For failures with error codes, can include the code in the message.
  /// Example: "Server error (500)"
  static String getLocalizedMessageWithCode(Failure failure) {
    final message = getLocalizedMessage(failure);
    if (failure.code != null) {
      return '$message (${failure.code})';
    }
    return message;
  }
}
