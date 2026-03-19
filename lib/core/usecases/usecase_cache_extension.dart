import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/model/i_params.dart';
import 'package:future_solutions/core/usecases/usecase.dart';

/// Extension on UseCase to support cache configuration.
extension UseCaseCacheExtension<Type, P extends Params> on UseCase<Type, P> {
  /// Calls the use case with cache configuration.
  ///
  /// This extension method allows passing cache configuration from the presentation layer.
  /// The actual caching is handled by the repository layer (BaseRepository).
  ///
  /// **Note**: This extension provides a way to pass cache config, but the repository
  /// must implement the caching logic using FetchDataParams with cache configuration.
  ///
  /// For now, this is a placeholder that calls the standard `call()` method.
  /// In the future, repositories can be updated to read cache config from a context
  /// or pass it through the call chain.
  Future<Either> callWithCache(
    P params, {
    Duration? ttl,
    bool forceRefresh = false,
    String? cacheKey,
  }) {
    // For now, just call the standard method
    // In a more sophisticated implementation, you might:
    // 1. Store cache config in a context/thread-local
    // 2. Have repositories read from context
    // 3. Or pass cache config through the call chain
    return call(params);
  }
}
