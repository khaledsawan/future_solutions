// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/serializer.dart' as _i138;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:openapi/openapi.dart' as _i711;

import '../core/extension/model_converter_helper.dart' as _i927;
import '../core/lifecycle/app_lifecycle_service.dart' as _i1073;
import '../core/network/network_info.dart' as _i6;
import '../core/network/network_info_impl.dart' as _i927;
import '../features/carts/data/implements/carts_repository_imp.dart' as _i145;
import '../features/carts/data/sources/carts_remote_data_source.dart' as _i622;
import '../features/carts/domain/repositories/carts_repository.dart' as _i434;
import '../features/carts/domain/usecases/add_cart_use_case/add_cart_use_case.dart'
    as _i819;
import '../features/carts/domain/usecases/delete_cart_use_case/delete_cart_use_case.dart'
    as _i791;
import '../features/carts/domain/usecases/get_all_carts_use_case/get_all_carts_use_case.dart'
    as _i211;
import '../features/carts/domain/usecases/get_cart_by_id_use_case/get_cart_by_id_use_case.dart'
    as _i692;
import '../features/carts/domain/usecases/update_cart_use_case/update_cart_use_case.dart'
    as _i944;
import '../features/products/data/implements/products_repository_imp.dart'
    as _i121;
import '../features/products/data/sources/products_remote_data_source.dart'
    as _i981;
import '../features/products/domain/repositories/products_repository.dart'
    as _i512;
import '../features/products/domain/usecases/add_product_use_case/add_product_use_case.dart'
    as _i45;
import '../features/products/domain/usecases/delete_product_use_case/delete_product_use_case.dart'
    as _i16;
import '../features/products/domain/usecases/get_all_products_use_case/get_all_products_use_case.dart'
    as _i423;
import '../features/products/domain/usecases/get_product_by_id_use_case/get_product_by_id_use_case.dart'
    as _i629;
import '../features/products/domain/usecases/update_product_use_case/update_product_use_case.dart'
    as _i784;
import 'modules/api_module.dart' as _i145;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final apiModule = _$ApiModule();
  gh.singleton<_i1073.AppLifecycleService>(() => _i1073.AppLifecycleService());
  gh.singleton<_i711.Openapi>(() => apiModule.openapi);
  gh.lazySingleton<_i361.Dio>(() => apiModule.dio(gh<_i711.Openapi>()));
  gh.lazySingleton<_i138.Serializers>(
    () => apiModule.serializers(gh<_i711.Openapi>()),
  );
  gh.singleton<_i6.INetworkInfo>(() => _i927.NetworkInfoImpl.create());
  gh.singleton<_i927.ModelConverterHelper>(
    () => _i927.ModelConverterHelper(gh<_i138.Serializers>()),
  );
  gh.singleton<_i622.CartsRemoteDataSource>(
    () => _i622.CartsRemoteDataSource(gh<_i361.Dio>(), gh<_i138.Serializers>()),
  );
  gh.singleton<_i981.ProductsRemoteDataSource>(
    () => _i981.ProductsRemoteDataSource(
      gh<_i361.Dio>(),
      gh<_i138.Serializers>(),
    ),
  );
  gh.lazySingleton<_i512.ProductsRepository>(
    () => _i121.ProductsRepositoryImp(
      remoteDataSource: gh<_i981.ProductsRemoteDataSource>(),
      networkInfo: gh<_i6.INetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i434.CartsRepository>(
    () => _i145.CartsRepositoryImp(
      remoteDataSource: gh<_i622.CartsRemoteDataSource>(),
      networkInfo: gh<_i6.INetworkInfo>(),
    ),
  );
  gh.factory<_i819.AddCartUseCase>(
    () => _i819.AddCartUseCase(gh<_i434.CartsRepository>()),
  );
  gh.factory<_i791.DeleteCartUseCase>(
    () => _i791.DeleteCartUseCase(gh<_i434.CartsRepository>()),
  );
  gh.factory<_i211.GetAllCartsUseCase>(
    () => _i211.GetAllCartsUseCase(gh<_i434.CartsRepository>()),
  );
  gh.factory<_i692.GetCartByIdUseCase>(
    () => _i692.GetCartByIdUseCase(gh<_i434.CartsRepository>()),
  );
  gh.factory<_i944.UpdateCartUseCase>(
    () => _i944.UpdateCartUseCase(gh<_i434.CartsRepository>()),
  );
  gh.factory<_i45.AddProductUseCase>(
    () => _i45.AddProductUseCase(gh<_i512.ProductsRepository>()),
  );
  gh.factory<_i16.DeleteProductUseCase>(
    () => _i16.DeleteProductUseCase(gh<_i512.ProductsRepository>()),
  );
  gh.factory<_i423.GetAllProductsUseCase>(
    () => _i423.GetAllProductsUseCase(gh<_i512.ProductsRepository>()),
  );
  gh.factory<_i629.GetProductByIdUseCase>(
    () => _i629.GetProductByIdUseCase(gh<_i512.ProductsRepository>()),
  );
  gh.factory<_i784.UpdateProductUseCase>(
    () => _i784.UpdateProductUseCase(gh<_i512.ProductsRepository>()),
  );
  return getIt;
}

class _$ApiModule extends _i145.ApiModule {}
