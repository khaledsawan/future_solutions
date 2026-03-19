import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/base/i_base_repo.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/extension/core_extension.dart';
import 'package:future_solutions/core/model/fetch_data_params.dart';
import 'package:future_solutions/core/model/i_params.dart';

class BaseRepository extends IBaseRepo {
  BaseRepository({required super.networkInfo});

  @override
  Future<Either<Object, T>> fetchData<T, P extends Params>({
    required FetchDataParams<T, P> params,
  }) async {
    return await _fetchDataLegacy(params);
  }

  /// Legacy fetch data method for backward compatibility.
  Future<Either<Object, T>> _fetchDataLegacy<T, P extends Params>(
    FetchDataParams<T, P> params,
  ) async {
    final isOffline = !networkInfo.isConnected;

    if (isOffline) {
      return const Left(CacheFailure('No cache available'));
    }

    final apiResult = _normalizeEither(
      await Task(
        () => params.getData(params.requestParams),
      ).attempt().mapLeftToFailure().run().then((value) => value),
    );

    return apiResult;
  }

  /// Normalizes nested Either results (e.g., Left(Left(Failure))).
  Either<Object, T> _normalizeEither<T>(Either<Object, T> value) {
    return value.fold((error) {
      if (error is Either<Object, T>) {
        return error;
      }
      return Left(error);
    }, (data) => Right(data));
  }
}
