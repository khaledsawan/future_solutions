class ServerException implements Exception {}

class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
  
  @override
  String toString() => message != null ? 'CacheException: $message' : 'CacheException';
}
