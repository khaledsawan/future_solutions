/// Base abstract class for feature services in the presentation layer.
///
/// This service provides a convenient way to call use cases with cache configuration.
/// Extend this class in your feature services to get easy access to cache configuration.
///
/// Example:
/// ```dart
/// class UserFeature extends GetService {
///   late UserUseCase userUseCase;
///   
///   UserFeature({required this.userUseCase});
///   
///   Future<Either<Failure, User>> getUser({
///     CacheType cacheType = CacheType.persistent,
///     Duration? ttl,
///     bool Function(User cachedData, GetUserParams params)? hashChecker,
///     bool forceRefresh = false,
///   }) {
///     return userUseCase.callWithCache(
///       GetUserParams(id: userId),
///       cacheType: cacheType,
///       ttl: ttl ?? Duration(hours: 1),
///       hashChecker: hashChecker,
///       forceRefresh: forceRefresh,
///     );
///   }
///   
///   @cached
///   Theme selectTheme() {
///     return Theme.light;
///   }
/// }
/// ```
abstract class GetService {
  // Base class - can be extended with feature-specific methods
  // This is a marker interface that encourages the pattern
}
