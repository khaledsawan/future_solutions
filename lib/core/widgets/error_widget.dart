import 'package:flutter/material.dart';
import 'package:future_solutions/core/error/error_display_helper.dart';
import 'package:future_solutions/core/error/failure.dart';

/// Shows an error message in a snackbar.
///
/// Usage:
/// ```dart
/// final result = await useCase.call(params);
/// result.fold(
///   (failure) => ErrorSnackbar.show(context, failure),
///   (data) => // handle success
/// );
/// ```
class ErrorSnackbar {
  /// Shows an error snackbar with localized message.
  static void show(
    BuildContext context,
    Failure failure, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              ErrorDisplayHelper.getErrorIcon(failure),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ErrorDisplayHelper.getErrorText(failure),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: ErrorDisplayHelper.getErrorColor(
          failure,
          context: context,
        ),
        duration: duration,
        action:
            action ??
            (ErrorDisplayHelper.getErrorAction(failure) != null
                ? SnackBarAction(
                    label: ErrorDisplayHelper.getErrorAction(failure)!,
                    textColor: Colors.white,
                    onPressed: () {
                      // Handle retry - should be provided by caller
                    },
                  )
                : null),
      ),
    );
  }
}

/// Shows an error dialog.
///
/// Usage:
/// ```dart
/// final result = await useCase.call(params);
/// result.fold(
///   (failure) => ErrorDialog.show(context, failure),
///   (data) => // handle success
/// );
/// ```
class ErrorDialog {
  /// Shows an error dialog with localized message.
  static Future<void> show(
    BuildContext context,
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          ErrorDisplayHelper.getErrorIcon(failure),
          color: ErrorDisplayHelper.getErrorColor(failure, context: context),
          size: 48,
        ),
        title: Text(ErrorDisplayHelper.getErrorTitle(failure)),
        content: Text(ErrorDisplayHelper.getErrorText(failure)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (onRetry != null &&
              ErrorDisplayHelper.getErrorAction(failure) != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: Text(ErrorDisplayHelper.getErrorAction(failure)!),
            ),
        ],
      ),
    );
  }
}

/// A banner widget that displays an error message.
///
/// Can be used at the top of a screen to show persistent errors.
class ErrorBanner extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;

  const ErrorBanner({
    super.key,
    required this.failure,
    this.onDismiss,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorColor = ErrorDisplayHelper.getErrorColor(
      failure,
      context: context,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: errorColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(ErrorDisplayHelper.getErrorIcon(failure), color: errorColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ErrorDisplayHelper.getErrorTitle(failure),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: errorColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ErrorDisplayHelper.getErrorText(failure),
                  style: TextStyle(color: errorColor),
                ),
              ],
            ),
          ),
          if (onRetry != null &&
              ErrorDisplayHelper.getErrorAction(failure) != null)
            TextButton(
              onPressed: onRetry,
              child: Text(ErrorDisplayHelper.getErrorAction(failure)!),
            ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDismiss,
              iconSize: 20,
              color: errorColor,
            ),
        ],
      ),
    );
  }
}
