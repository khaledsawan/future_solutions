import 'package:flutter/material.dart';
import 'package:future_solutions/core/error/error_localization_service.dart';
import 'package:future_solutions/core/error/failure.dart';

/// Extension on Failure to provide easy access to localized messages.
extension FailureExtension on Failure {
  /// Gets the localized error message for this failure.
  String get localizedMessage =>
      ErrorLocalizationService.getLocalizedMessage(this);

  /// Gets the localization key for this failure.
  String? get localizationKey =>
      ErrorLocalizationService.getErrorMessageKey(this);
}

/// Helper mixin/class for displaying errors in the presentation layer.
///
/// Provides methods to get error text, icons, colors, and titles
/// for different failure types.
class ErrorDisplayHelper {
  /// Gets the localized error text for a Failure.
  ///
  /// Returns empty string if failure is null.
  static String getErrorText(Failure? failure) {
    if (failure == null) return '';
    return ErrorLocalizationService.getLocalizedMessage(failure);
  }

  /// Gets the error title (optional) for a Failure.
  ///
  /// Can be used in dialogs or banners to show error category.
  static String getErrorTitle(Failure? failure) {
    if (failure == null) return '';

    if (failure is NetworkFailure) {
      return 'Network Error';
    } else if (failure is TimeoutFailure) {
      return 'Timeout Error';
    } else if (failure is AuthFailure || failure is ForbiddenFailure) {
      return 'Authentication Error';
    } else if (failure is ServerFailure) {
      return 'Server Error';
    } else if (failure is ParsingFailure) {
      return 'Parsing Error';
    } else if (failure is CacheFailure) {
      return 'Cache Error';
    } else if (failure is ValidationFailure) {
      return 'Validation Error';
    } else {
      return 'Error';
    }
  }

  /// Gets an appropriate icon for the failure type.
  static IconData getErrorIcon(Failure failure) {
    if (failure is NetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is TimeoutFailure) {
      return Icons.timer_off;
    } else if (failure is AuthFailure || failure is ForbiddenFailure) {
      return Icons.lock_outline;
    } else if (failure is ServerFailure) {
      return Icons.error_outline;
    } else if (failure is ParsingFailure) {
      return Icons.code_off;
    } else if (failure is CacheFailure) {
      return Icons.storage;
    } else if (failure is ValidationFailure) {
      return Icons.check_circle_outline;
    } else if (failure is CancelFailure) {
      return Icons.cancel_outlined;
    } else {
      return Icons.warning_amber_rounded;
    }
  }

  /// Gets an appropriate color for the failure type.
  static Color getErrorColor(Failure failure, {required BuildContext context}) {
    final theme = Theme.of(context);

    if (failure is NetworkFailure) {
      return Colors.orange;
    } else if (failure is TimeoutFailure) {
      return Colors.amber;
    } else if (failure is AuthFailure || failure is ForbiddenFailure) {
      return Colors.red;
    } else if (failure is ServerFailure) {
      return Colors.red.shade700;
    } else if (failure is ParsingFailure) {
      return Colors.purple;
    } else if (failure is CacheFailure) {
      return Colors.blue;
    } else if (failure is ValidationFailure) {
      return Colors.deepOrange;
    } else if (failure is CancelFailure) {
      return theme.colorScheme.secondary;
    } else {
      return theme.colorScheme.error;
    }
  }

  /// Gets a snackbar action (optional) for specific failure types.
  ///
  /// For example, "Retry" for network errors.
  static String? getErrorAction(Failure failure) {
    if (failure is NetworkFailure ||
        failure is TimeoutFailure ||
        failure is ServerFailure) {
      return 'Retry';
    }
    return null;
  }
}
