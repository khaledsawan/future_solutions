import 'package:dio/dio.dart' show DioException, DioExceptionType, Response;
import 'package:future_solutions/core/error/failure.dart';

class DioErrorMapper {
  static Failure map(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.cancel:
        return const CancelFailure();

      case DioExceptionType.badResponse:
        return _mapBadResponse(exception.response);

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return _mapUnknown(exception);
    }
  }

  static Failure _mapBadResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;

    // Handle authentication and authorization errors
    if (statusCode == 401) {
      return const AuthFailure();
    }
    if (statusCode == 403) {
      return const ForbiddenFailure();
    }

    final data = response?.data;
    String? errorMessage;

    // Try multiple error response formats
    if (data is Map<String, dynamic>) {
      // Format 1: { "error": { "message": "...", "code": 400 } }
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        errorMessage = error['message']?.toString();
      }

      // Format 2: { "message": "..." }
      if (errorMessage == null && data['message'] != null) {
        errorMessage = data['message']?.toString();
      }

      // Format 3: { "error": "..." } (string)
      if (errorMessage == null && error is String) {
        errorMessage = error;
      }

      // Format 4: { "errors": ["error1", "error2"] } or { "errors": { "field": ["error"] } }
      if (errorMessage == null && data['errors'] != null) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          errorMessage = errors.first?.toString();
        } else if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          // Extract first error from field-based errors
          final firstErrorEntry = errors.entries.first;
          final fieldErrors = firstErrorEntry.value;
          if (fieldErrors is List && fieldErrors.isNotEmpty) {
            errorMessage = fieldErrors.first?.toString();
          } else if (fieldErrors is String) {
            errorMessage = fieldErrors;
          }
        }
      }
    } else if (data is String) {
      // Format 5: Plain string error
      errorMessage = data;
    }

    // Use ServerFailure.fromStatusCode for proper localization key mapping
    return ServerFailure.fromStatusCode(
      message: errorMessage ?? 'Server error',
      statusCode: statusCode,
    );
  }

  static Failure _mapUnknown(DioException e) {
    if (e.error is FormatException) {
      return const ParsingFailure();
    }
    return UnknownFailure(e.message ?? 'Unknown error');
  }
}
