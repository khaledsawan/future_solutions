# Core Module

The Core module contains shared abstractions, utilities, and infrastructure that can be used across all layers of the application.

## Purpose

Core provides:
- Shared interfaces and abstractions for replaceable services
- Common models and base classes
- Error handling infrastructure
- Reusable UI widgets and helpers
- Platform/infrastructure abstractions

## Structure

```
lib/core/
├── base/              # Base repository abstractions
├── cache/             # Three-tier caching system
│   ├── impl/          # Cache implementations
│   ├── cache_manager.dart
│   ├── cache_config.dart
│   ├── cache_key_generator.dart
│   ├── cache_utils.dart
│   ├── hash_checker.dart
│   └── cache_type.dart
├── dio/               # HTTP error mapping infrastructure
├── error/             # Error handling system
├── extension/         # Core extensions
├── lifecycle/         # App lifecycle management
├── model/             # Core models & contracts
├── network/           # Network abstractions
├── service/           # Presentation layer services
│   └── get_service.dart
├── usecases/          # Use case contracts
└── widgets/           # Shared UI widgets
```

## Key Components

### Base (`base/`)

- **`IBaseRepo`**: Abstract interface for repository base functionality
- **`BaseRepository`**: Base implementation providing common data fetching logic
  - Handles network connectivity checking
  - Provides error handling via `Task.attempt()`
  - Supports optional caching and offline fallback

**Usage:**
```dart
class MyRepository extends BaseRepository implements IMyRepository {
  MyRepository({required super.networkInfo});
  
  @override
  Future<Either<Object, User>> getUser(String id) {
    return fetchData<User, GetUserParams>(
      params: FetchDataParams(
        getData: (params) async {
          final response = await remoteDataSource.getUser(id: params.id);
          return response.data;
        },
        requestParams: GetUserParams(id: id),
      ),
    );
  }
}
```

### Error Handling (`error/`)

Comprehensive error handling system with localization support.

- **`Failure`**: Base class for all error types
  - `NetworkFailure`, `TimeoutFailure`, `ServerFailure`, `AuthFailure`, etc.
- **`ErrorLocalizationService`**: Service for localizing error messages
- **`ErrorDisplayHelper`**: Utilities for displaying errors in UI
- **`exceptions.dart`**: Exception definitions (`CacheException`, `ServerException`)

**Usage:**
```dart
// In repository
result.fold(
  (failure) {
    // Handle failure - failure is automatically mapped from exceptions
    final message = failure.localizedMessage;
    return Left(failure);
  },
  (data) => Right(data),
);

// In presentation
result.fold(
  (failure) => ErrorSnackbar.show(context, failure),
  (data) => // handle success
);
```

See [Error Handling Documentation](../../docs/ERROR_HANDLING.md) for detailed usage.

### Dio (`dio/`)

- **`DioErrorMapper`**: Maps `DioException` to `Failure` objects
  - Supports multiple server error response formats
  - Handles network, timeout, authentication, and server errors

**Note:** Dio is an acceptable dependency in core for error mapping infrastructure. This is documented in `docs/architecture.md`.

### Extensions (`extension/`)

- **`TaskX`**: Extension on `Task<Either>` for automatic error mapping
  - `mapLeftToFailure()`: Automatically maps exceptions to `Failure` objects

**Usage:**
```dart
Task(() => someAsyncOperation())
  .attempt()
  .mapLeftToFailure()  // Maps exceptions to Failures
  .run();
```

### Lifecycle (`lifecycle/`)

- **`IAppLifecycleService`**: Interface for app lifecycle state management
- **`AppLifecycleService`**: Implementation tracking app state changes
- **`AppLifecycleCoordinator`**: Coordinates lifecycle events

### Models (`model/`)

- **`Params`**: Base interface for use case parameters
- **`FetchDataParams`**: Parameters for `BaseRepository.fetchData()`
- **`NoParams`**: Parameter class for use cases with no input

### Network (`network/`)

- **`INetworkInfo`**: Interface for network connectivity checking
- **`NetworkInfoImpl`**: Implementation using `internet_connection_checker_plus`
- Properly abstracted - can be swapped via Dependency Injection

### Use Cases (`usecases/`)

- **`UseCase<Type, Params>`**: Base abstract class for all use cases
- **`IUseCaseEntity<Entity, DTO>`**: Interface for entity-DTO mapping (when using custom entities)
- **`UseCaseCacheExtension`**: Extension for cache configuration support

### Cache (`cache/`)

Three-tier caching system with offline mode and hash checking support.

- **`CacheManager`**: Manages all three cache types with unified interface
- **`ICache`**, **`IMemoryCache`**, **`IPersistentCache`**, **`ISecureCache`**: Cache interfaces
- **`CacheType`**: Enum for cache types (memory, persistent, secure)
- **`HashChecker`**: Utility for cache freshness validation
- **`CacheKeyGenerator`**: Generates unique cache keys from request parameters
- **`CacheUtils`**: Helper utilities for cache management and statistics

**Cache Types:**
- **Memory**: In-memory storage (lost on restart) - fastest
- **Persistent**: Local file storage (survives restart) - medium speed
- **Secure**: Encrypted storage (survives restart + protected) - for sensitive data

**Usage:**
```dart
// In repository
return fetchData<User, GetUserParams>(
  params: FetchDataParams(
    getData: (params) async {
      final response = await remoteDataSource.getUser(id: params.id);
      return response.data;
    },
    requestParams: GetUserParams(id: id),
    cacheType: CacheType.persistent,
    ttl: Duration(hours: 1),
    hashChecker: (cachedUser, params) => cachedUser.hash != serverHash,
  ),
);
```

See [Caching Documentation](../../docs/CACHING.md) for detailed usage.

### Service (`service/`)

- **`GetService`**: Base abstract class for presentation layer feature services
  - Provides convenient pattern for calling use cases with cache configuration
  - Supports method-level caching with `@cached` annotations

### Widgets (`widgets/`)

Shared UI components for error display:

- **`ErrorSnackbar`**: Shows error messages in snackbars
- **`ErrorDialog`**: Shows error messages in dialogs
- **`ErrorBanner`**: Shows persistent error banners

**Usage:**
```dart
// Snackbar
ErrorSnackbar.show(context, failure);

// Dialog
ErrorDialog.show(
  context,
  failure,
  onRetry: () => _retryOperation(),
);

// Banner
ErrorBanner(
  failure: failure,
  onDismiss: () => setState(() => hasError = false),
  onRetry: () => _retryOperation(),
)
```

## Architectural Guidelines

### What Belongs in Core

✅ **Put in Core if:**
- Used by multiple features or layers
- Provides infrastructure/abstraction rather than business logic
- Is a shared utility or helper
- Defines contracts/interfaces for replaceable services
- Is reusable across the application

❌ **Put in Feature if:**
- Specific to a single feature's domain
- Contains business logic
- Is a feature-specific entity or use case
- Implements feature-specific requirements

### Dependencies

Core can depend on:
- **Dartz**: Functional programming utilities (`Either`, `Task`)
- **Dio**: HTTP error mapping infrastructure (documented exception)
- **Flutter**: For lifecycle services and UI widgets
- **Equatable**: For value equality

Core should **NOT** depend on:
- Feature-specific code
- Business domain models
- Third-party service implementations (except documented exceptions)

### Interface/Implementation Pattern

Core follows the "Replaceable Services Rule":
- Interfaces defined in core (e.g., `INetworkInfo`)
- Implementations can be in core or data layer
- Services are swappable via Dependency Injection

**Example:**
```dart
// Interface in core
abstract class INetworkInfo {
  bool get isConnected;
}

// Implementation (can be in core or data layer)
class NetworkInfoImpl implements INetworkInfo {
  // Implementation details
}
```

## Error Handling Flow

```
Exception/Error → Task.attempt() → mapLeftToFailure() → Failure → Localization → UI
```

1. Exceptions are caught by `Task.attempt()` in `BaseRepository`
2. `mapLeftToFailure()` converts exceptions to typed `Failure` objects
3. `Failure` objects contain localization keys
4. `ErrorLocalizationService` translates messages
5. UI helpers display localized errors

## Testing

When testing core components:

```dart
// Test network info
test('should return false when offline', () {
  when(mockNetworkInfo.isConnected).thenReturn(false);
  expect(networkInfo.isConnected, false);
});

// Test error mapping
test('should map DioException to NetworkFailure', () {
  final dioError = DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: DioExceptionType.connectionError,
  );
  final failure = DioErrorMapper.map(dioError);
  expect(failure, isA<NetworkFailure>());
});
```

## Related Documentation

- [Architecture Contract](../../docs/architecture.md) - Overall architecture rules
- [Error Handling Guide](../../docs/ERROR_HANDLING.md) - Detailed error handling documentation
- [Caching Documentation](../../docs/CACHING.md) - Comprehensive caching system guide
- [Instructions](../../docs/instructions.md) - Development guidelines

## Maintenance

When adding new components to core:

1. Ensure it's truly shared across features
2. Follow interface/implementation pattern for services
3. Keep pure Dart components separate from Flutter components
4. Document any exceptions to dependency rules
5. Add tests for new components
6. Update this README if adding new folders/components