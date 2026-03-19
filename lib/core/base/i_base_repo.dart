import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/model/fetch_data_params.dart';
import 'package:future_solutions/core/model/i_params.dart';
import 'package:future_solutions/core/network/network_info.dart'
    show INetworkInfo;

abstract class IBaseRepo {
  final INetworkInfo networkInfo;

  IBaseRepo({required this.networkInfo});

  Future<Either<Object, T>> fetchData<T, P extends Params>({
    required FetchDataParams<T, P> params,
  });
}
