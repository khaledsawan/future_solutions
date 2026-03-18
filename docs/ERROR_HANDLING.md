# Error Handling & Localization Guide

## Overview

The error handling system provides a comprehensive, localized error management solution for the Flutter application. It supports multiple error types, automatic localization, and easy-to-use presentation layer helpers.

## Architecture

### Error Flow

```
Exception/Error → Error Mapper → Failure → Localization Service → UI Display
```

1. **Exceptions/Errors** are caught by `Task.attempt()` in `BaseRepository`
2. **Error Mappers** convert exceptions to typed `Failure` objects
3. **Failure** classes contain error information and localization keys
4. **Localization Service** translates error messages based on current locale
5. **UI Helpers** display errors in user-friendly formats

## Core Components

### Failure Classes

All failure types extend the base `Failure` class and include localization keys:

- `NetworkFailure` - No internet connection
- `TimeoutFailure` - Request timeout
- `ServerFailure` - Server error responses (supports dynamic messages)
- `AuthFailure` - Unauthorized (401)
- `ForbiddenFailure` - Forbidden (403)
- `CancelFailure` - Request cancelled
- `ParsingFailure` - JSON/response parsing errors
- `CacheFailure` - Cache operation failures
- `ValidationFailure` - Input validation errors
- `UnknownFailure` - Fallback for unknown errors

#### Example Usage

```dart
// Failure with localization key
const failure = NetworkFailure();
print(failure.localizationKey); // 'errors.network'

// ServerFailure with dynamic message
final serverFailure = ServerFailure(
  message: 'User not found',
  code: 404,
);
// Automatically uses 'errors.server.404' localization key
```

### Error Mappers

#### DioErrorMapper

Maps `DioException` to appropriate `Failure` classes:

- Network errors → `NetworkFailure`
- Timeouts → `TimeoutFailure`
- HTTP errors → `ServerFailure` (with status code mapping)
- Parsing errors → `ParsingFailure`

Supports multiple server error response formats:
- `{ "error": { "message": "..." } }`
- `{ "message": "..." }`
- `{ "errors": ["..."] }`
- `{ "errors": { "field": ["..."] } }`

#### Task Extension

The `TaskX` extension on `Task<Either>` automatically maps exceptions to failures:

```dart
Task(() => someAsyncOperation())
  .attempt()
  .mapLeftToFailure() // Maps all exceptions to Failures
  .run();
```

### Error Localization Service

`ErrorLocalizationService` provides methods to get localized error messages:

```dart
// Get localized message
final message = ErrorLocalizationService.getLocalizedMessage(failure);

// Get localization key
final key = ErrorLocalizationService.getErrorMessageKey(failure);
```

**Message Resolution Priority:**
1. Server-provided message (for `ServerFailure` with meaningful message)
2. Localized message from key (via easy_localization)
3. Fallback to hardcoded English message

### Presentation Layer Helpers

#### ErrorDisplayHelper

Provides utilities for displaying errors:

```dart
// Get error text
final text = ErrorDisplayHelper.getErrorText(failure);

// Get error icon
final icon = ErrorDisplayHelper.getErrorIcon(failure);

// Get error color
final color = ErrorDisplayHelper.getErrorColor(failure, context: context);

// Get error title
final title = ErrorDisplayHelper.getErrorTitle(failure);
```

#### Failure Extension

Direct access to localized messages:

```dart
final failure = NetworkFailure();
print(failure.localizedMessage); // Localized message based on current locale
print(failure.localizationKey); // 'errors.network'
```

#### Error Widgets

**ErrorSnackbar:**
```dart
final result = await useCase.call(params);
result.fold(
  (failure) => ErrorSnackbar.show(context, failure),
  (data) => // handle success
);
```

**ErrorDialog:**
```dart
final result = await useCase.call(params);
result.fold(
  (failure) => ErrorDialog.show(
    context,
    failure,
    onRetry: () => _retryOperation(),
  ),
  (data) => // handle success
);
```

**ErrorBanner:**
```dart
if (hasError) {
  ErrorBanner(
    failure: failure,
    onDismiss: () => setState(() => hasError = false),
    onRetry: () => _retryOperation(),
  )
}
```

## Localization

### Adding New Error Messages

1. **Add translation keys** to locale files:
   ```json
   // lib/l10n/locales/en.json
   {
     "errors": {
       "custom_error": "Custom error message"
     }
   }
   ```

2. **Create or update Failure class:**
   ```dart
   class CustomFailure extends Failure {
     static const String key = 'errors.custom_error';
     
     const CustomFailure() 
         : super(
             'Custom error message',
             localizationKey: key,
           );
   }
   ```

### Supported Locales

- English (`en`)
- Arabic (`ar`)

To add more locales, create new JSON files in `lib/l10n/locales/` and update `main.dart`.

## Usage Examples

### In Repository Implementation

```dart
@override
Future<Either<dynamic, User>> getUser(String id) async {
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
```

### In Use Case

```dart
class GetUserUseCase extends UseCase<User, GetUserParams> {
  final UserRepository repository;
  
  GetUserUseCase({required this.repository});
  
  @override
  Future<Either> call(GetUserParams params) => 
    repository.getUser(id: params.id);
}
```

### In Presentation Layer

```dart
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either>(
      future: useCase.call(GetUserParams(id: userId)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (failure) {
              // Show error
              ErrorSnackbar.show(context, failure);
              return ErrorView();
            },
            (user) => UserView(user: user),
          );
        }
        return LoadingView();
      },
    );
  }
}
```

### Handling Specific Error Types

```dart
result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      // Show offline message
      showOfflineBanner();
    } else if (failure is AuthFailure) {
      // Redirect to login
      Navigator.pushNamed(context, '/login');
    } else {
      // Show generic error
      ErrorSnackbar.show(context, failure);
    }
  },
  (data) => // handle success
);
```

## Best Practices

1. **Always use `mapLeftToFailure()`** after `Task.attempt()` to ensure proper error mapping
2. **Prefer localized error messages** over hardcoded strings
3. **Use appropriate error widgets** (Snackbar for transient errors, Dialog for critical errors)
4. **Handle cache errors gracefully** - provide fallback UI when cache fails
5. **Log errors** before displaying to users (for debugging)
6. **Provide retry actions** for recoverable errors (network, timeout, server)

## Adding New Error Types

1. Create new Failure class in `lib/core/error/failure.dart`
2. Add localization keys to all locale files
3. Update `ErrorDisplayHelper` if needed (for icons, colors, titles)
4. Update error mappers if the error comes from a specific source

## Testing

When testing error handling:

```dart
test('should return NetworkFailure when no internet', () async {
  when(mockNetworkInfo.isConnected).thenAnswer((_) => false);
  
  final result = await repository.getData();
  
  expect(result.isLeft(), true);
  result.fold(
    (failure) => expect(failure, isA<NetworkFailure>()),
    (_) => fail('Should return failure'),
  );
});
```

## Migration Guide

If you have existing error handling code:

1. **Replace hardcoded error messages** with Failure classes
2. **Update UI code** to use `ErrorDisplayHelper` and error widgets
3. **Add localization keys** for all error messages
4. **Test error scenarios** to ensure proper localization

## Troubleshooting

### Error messages not localizing

- Check that locale files exist in `lib/l10n/locales/`
- Verify keys match exactly (including nested structure)
- Ensure `EasyLocalization` is initialized in `main.dart`
- Check that `context.locale` is set correctly

### Cache errors not being caught

- Ensure cache operations are wrapped in `Task.attempt()`
- Verify `CacheException` is thrown from cache layer
- Check that `TaskX.mapLeftToFailure()` is called

### Server error parsing issues

- Verify server error response format matches supported formats
- Check `DioErrorMapper._mapBadResponse()` for format support
- Consider adding custom parsing for your API format