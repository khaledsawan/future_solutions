import 'package:future_solutions/core/model/i_params.dart';

class FetchDataParams<T, P extends Params> extends Params {
  /// Function that fetches data from remote source.
  ///
  /// Must return `Future<T>` (not `Future<Response<T>>`).
  /// Extract `.data` from Response inside this function.
  final Future<T> Function(P params) getData;

  /// Request parameters passed to `getData` function.
  final P requestParams;

  /// Time-to-live duration for cached data.
  /// If null, uses default TTL for the cache type.
  final Duration? ttl;

  /// If true, bypasses cache and always fetches from API.
  final bool forceRefresh;

  /// Custom cache key. If null, will be auto-generated from method name and params.
  final String? cacheKey;

  /// Hash checker function that validates cache freshness.
  /// Returns `true` if hash changed (should fetch from API),
  /// `false` if hash unchanged (can use cached data).

  const FetchDataParams({
    required this.getData,
    required this.requestParams,
    this.ttl,
    this.forceRefresh = false,
    this.cacheKey,
  });
}
