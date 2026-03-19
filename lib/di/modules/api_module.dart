import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:future_solutions/core/config.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

@module
abstract class ApiModule {
  @singleton
  Openapi get openapi => Openapi(
    dio: Dio(BaseOptions(baseUrl: baseUrl)),
    serializers: standardSerializers,
  );

  @lazySingleton
  Dio dio(Openapi openapi) => openapi.dio;

  @lazySingleton
  Serializers serializers(Openapi openapi) => openapi.serializers;
}
