abstract class Failure {
  final String message;
  final int? code;
  final String? localizationKey;

  const Failure(this.message, {this.code, this.localizationKey});

  /// Returns the localization key for this failure type.
  /// Override in subclasses to provide specific keys.
  String? get errorKey => localizationKey;
}

/// No internet / DNS
class NetworkFailure extends Failure {
  static const String key = 'errors.network';

  const NetworkFailure()
    : super('No internet connection', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Request timeout
class TimeoutFailure extends Failure {
  static const String key = 'errors.timeout';

  const TimeoutFailure() : super('Request timed out', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Server returned an error response
class ServerFailure extends Failure {
  static const String keyGeneric = 'errors.server.generic';

  const ServerFailure({
    required String message,
    int? code,
    String? localizationKey,
  }) : super(
         message,
         code: code,
         localizationKey: localizationKey ?? keyGeneric,
       );

  /// Creates a ServerFailure with a localized key based on HTTP status code
  factory ServerFailure.fromStatusCode({
    required String message,
    required int statusCode,
  }) {
    final codeKey = _getStatusCodeKey(statusCode);
    return ServerFailure(
      message: message,
      code: statusCode,
      localizationKey: codeKey,
    );
  }

  static String _getStatusCodeKey(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'errors.server.400';
      case 401:
        return 'errors.server.401';
      case 403:
        return 'errors.server.403';
      case 404:
        return 'errors.server.404';
      case 500:
        return 'errors.server.500';
      case 502:
        return 'errors.server.502';
      case 503:
        return 'errors.server.503';
      default:
        return keyGeneric;
    }
  }

  @override
  String? get errorKey => localizationKey ?? keyGeneric;
}

/// 401 / 403
class AuthFailure extends Failure {
  static const String key = 'errors.unauthorized';

  const AuthFailure() : super('Unauthorized access', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// 403 Forbidden
class ForbiddenFailure extends Failure {
  static const String key = 'errors.forbidden';

  const ForbiddenFailure() : super('Access forbidden', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Cancelled request
class CancelFailure extends Failure {
  static const String key = 'errors.cancelled';

  const CancelFailure() : super('Request was cancelled', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Serialization / parsing error
class ParsingFailure extends Failure {
  static const String key = 'errors.parsing';

  const ParsingFailure()
    : super('Failed to parse response', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Unknown fallback
class UnknownFailure extends Failure {
  static const String key = 'errors.unknown';

  const UnknownFailure(super.message) : super(localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Cache operation failed
class CacheFailure extends Failure {
  static const String key = 'errors.cache';

  const CacheFailure([String? message])
    : super(message ?? 'Failed to read cached data', localizationKey: key);

  @override
  String? get errorKey => key;
}

/// Validation failed (input/domain validation errors)
class ValidationFailure extends Failure {
  static const String key = 'errors.validation';
  final Map<String, String>? fieldErrors;

  const ValidationFailure({String? message, this.fieldErrors})
    : super(message ?? 'Validation failed', localizationKey: key);

  @override
  String? get errorKey => key;
}
