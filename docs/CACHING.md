# Caching System Documentation

## Overview

The caching system provides a three-tier caching solution integrated with `BaseRepository` and the presentation layer:

1. **Memory Cache**: In-memory storage (lost on app restart) - fastest access
2. **Persistent Cache**: Local storage (survives app restart) - file/database storage
3. **Secure Cache**: Encrypted storage (survives restart + protected) - for sensitive data

## Features

- **Three-tier caching**: Memory, Persistent, and Secure cache types
- **Hash checking**: Validate cache freshness before using cached data
- **Offline mode**: Intelligent cache strategy based on network connectivity
- **TTL support**: Time-to-live for automatic cache expiration
- **Cache invalidation**: Clear cache by key, pattern, or type
- **Presentation layer integration**: Easy-to-use service classes with `GetService` pattern
- **Method-level caching**: Support for `@cached` annotations (requires `build_runner`)

## Architecture

### Cache Flow

```
Presentation Layer (GetService)
    ↓
UseCase (with cache config)
    ↓
Repository (BaseRepository)
    ↓
CacheManager → ICache (Memory/Persistent/Secure)
```

### Offline Mode Behavior

- **When offline**: System checks cache first, returns cached data if available, otherwise returns `CacheFailure`
- **When online**: 
  - If `forceRefresh == false`: Check cache → validate hash (if provided) → return cached data or fetch from API
  - If `forceRefresh == true`: Always fetch from API and update cache

## Usage

### Repository Layer

#### Basic Usage

```dart
@override
Future<Either<dynamic, User>> getUser(String id) {
  return fetchData<User, GetUserParams>(
    params: FetchDataParams(
      getData: (params) async {
        final response = await remoteDataSource.getUser(id: params.id);
        return response.data;
      },
      requestParams: GetUserParams(id: id),
      cacheType: CacheType.persistent,
      ttl: Duration(hours: 1),
    ),
  );
}
```

#### With Hash Checking

```dart
@override
Future<Either<dynamic, User>> getUser(String id) {
  return fetchData<User, GetUserParams>(
    params: FetchDataParams(
      getData: (params) async {
        final response = await remoteDataSource.getUser(id: params.id);
        return response.data;
      },
      requestParams: GetUserParams(id: id),
      cacheType: CacheType.persistent,
      ttl: Duration(hours: 1),
      hashChecker: (cachedUser, params) {
        // Return true if hash changed (fetch from API)
        // Return false if hash unchanged (use cache)
        final serverHash = await getServerHash(params.id);
        return cachedUser.hash != serverHash;
      },
    ),
  );
}
```

#### Secure Cache for Sensitive Data

```dart
@override
Future<Either<dynamic, AuthToken>> getAuthToken() {
  return fetchData<AuthToken, GetTokenParams>(
    params: FetchDataParams(
      getData: (params) async {
        final response = await remoteDataSource.getToken();
        return response.data;
      },
      requestParams: GetTokenParams(),
      cacheType: CacheType.secure,
      ttl: Duration(days: 7),
    ),
  );
}
```

### Presentation Layer

#### Using GetService Pattern

```dart
class UserFeature extends GetService {
  late UserUseCase userUseCase;
  
  UserFeature({required this.userUseCase});
  
  Future<Either<Failure, User>> getUser({
    CacheType cacheType = CacheType.persistent,
    Duration? ttl,
    bool Function(User cachedData, GetUserParams params)? hashChecker,
    bool forceRefresh = false,
  }) {
    return userUseCase.callWithCache(
      GetUserParams(id: userId),
      cacheType: cacheType,
      ttl: ttl ?? Duration(hours: 1),
      hashChecker: hashChecker,
      forceRefresh: forceRefresh,
    );
  }
}

// Usage
final userFeature = UserFeature(userUseCase: userUseCase);

// Get user with persistent cache
final result = await userFeature.getUser(
  cacheType: CacheType.persistent,
  ttl: Duration(hours: 1),
);

// Force refresh (bypass cache)
final freshUser = await userFeature.getUser(forceRefresh: true);

// With hash checking
final result = await userFeature.getUser(
  cacheType: CacheType.persistent,
  hashChecker: (cachedUser, params) => cachedUser.version != latestVersion,
);
```

#### Method-Level Caching

For non-API methods, you can use the `@cached` annotation from the `cached` package:

```dart
import 'package:cached/cached.dart';

class ThemeService extends GetService {
  @cached
  Theme selectTheme() {
    return Theme.light;
  }
  
  @cached
  String getAppVersion() {
    return '1.0.0';
  }
}
```

**Note**: Method-level caching requires `build_runner`:

```bash
flutter pub run build_runner build
```

## Cache Types

### Memory Cache

- **Speed**: Fastest
- **Persistence**: Lost on app restart
- **Use case**: Frequently accessed, non-critical data
- **Example**: UI state, temporary data

### Persistent Cache

- **Speed**: Medium
- **Persistence**: Survives app restart
- **Use case**: API responses, user preferences
- **Example**: User profile, app settings

### Secure Cache

- **Speed**: Slower (encryption overhead)
- **Persistence**: Survives app restart
- **Security**: Encrypted (platform keychain/keystore)
- **Use case**: Sensitive data
- **Example**: Auth tokens, passwords, API keys

## Cache Configuration

### Default TTL Values

- Memory: 1 hour
- Persistent: 7 days
- Secure: 30 days

### Custom Configuration

```dart
final config = CacheConfig(
  defaultTtl: {
    CacheType.memory: Duration(minutes: 30),
    CacheType.persistent: Duration(days: 3),
    CacheType.secure: Duration(days: 14),
  },
  memoryCacheMaxSize: 50,
  persistentCacheMaxSizeBytes: 25 * 1024 * 1024, // 25 MB
);

final cacheManager = CacheManager(config: config);
```

## Hash Checking

Hash checking allows you to validate cache freshness by comparing cached data with the current state on the server.

### When to Use Hash Checking

- Data that changes frequently
- Need to minimize API calls but ensure freshness
- Server provides hash/version information

### Example Implementation

```dart
hashChecker: (cachedUser, params) async {
  // Fetch current hash from server
  final serverHash = await getServerHash(params.id);
  
  // Return true if hash changed (need to fetch)
  // Return false if hash unchanged (use cache)
  return cachedUser.hash != serverHash;
}
```

## Cache Invalidation

### Clear Specific Cache

```dart
await cacheManager.delete(CacheType.persistent, 'user_123');
```

### Clear All Cache of Type

```dart
await cacheManager.clear(CacheType.persistent);
```

### Clear All Caches

```dart
await CacheUtils.clearAll(cacheManager);
```

### Get Cache Statistics

```dart
final stats = await CacheUtils.getStats(cacheManager);
print('Memory items: ${stats.memoryItems}');
print('Persistent size: ${stats.persistentSizeBytes} bytes');
```

## Error Handling

Cache operations are designed to fail gracefully:

- Cache read errors return `CacheFailure` but don't break API calls
- If cache fails, system falls back to API (when online)
- When offline and cache fails, `CacheFailure` is returned

### Handling Cache Errors

```dart
final result = await repository.getUser(id: userId);
result.fold(
  (failure) {
    if (failure is CacheFailure) {
      // Handle cache error
      print('Cache error: ${failure.message}');
    }
    // Handle other errors
  },
  (user) => // Handle success
);
```

## Best Practices

1. **Choose the right cache type**:
   - Memory for temporary, frequently accessed data
   - Persistent for API responses, user data
   - Secure for sensitive information

2. **Set appropriate TTL**:
   - Short TTL for frequently changing data
   - Long TTL for static data
   - Consider data freshness requirements

3. **Use hash checking wisely**:
   - Only use when you have a reliable hash source
   - Keep hash checking logic lightweight
   - Don't use for data that changes too frequently

4. **Handle offline mode**:
   - Always provide meaningful error messages
   - Consider showing cached data even when slightly stale
   - Provide retry mechanisms

5. **Monitor cache size**:
   - Set appropriate max sizes
   - Monitor cache statistics
   - Clear old data when needed

6. **Test cache behavior**:
   - Test offline scenarios
   - Test cache expiration
   - Test cache invalidation

## Migration from Legacy Cache

The new caching system is backward compatible with the old `cacheData`/`cachedData` approach. However, you should migrate to the new system:

### Old Way (Deprecated)

```dart
FetchDataParams(
  getData: (params) async { ... },
  requestParams: params,
  needCache: true,
  cacheData: (data) async { ... },
  cachedData: () async { ... },
)
```

### New Way

```dart
FetchDataParams(
  getData: (params) async { ... },
  requestParams: params,
  cacheType: CacheType.persistent,
  ttl: Duration(hours: 1),
)
```

## Troubleshooting

### Cache not working

1. Ensure `CacheManager` is initialized: `await cacheManager.initialize()`
2. Check that `cacheType` is provided in `FetchDataParams`
3. Verify cache permissions (especially for persistent/secure cache)

### Cache always misses

1. Check cache key generation
2. Verify TTL hasn't expired
3. Check cache size limits

### Hash checker always returns true

1. Verify hash comparison logic
2. Check that server hash is being fetched correctly
3. Ensure hash format matches

## Dependencies

- `cached: ^1.8.1` - Method-level caching annotations
- `flutter_secure_storage: ^9.0.0` - Secure encrypted storage
- `crypto: ^3.0.3` - Hash generation utilities
- `path_provider: ^2.1.1` - Directory access for persistent cache

## See Also

- [Core Module README](../lib/core/README.md)
- [Architecture Documentation](./architecture.md)
- [Error Handling Guide](./ERROR_HANDLING.md)
