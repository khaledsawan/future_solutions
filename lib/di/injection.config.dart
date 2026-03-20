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
import '../features/carts/data/implements/cart_local_repository_imp.dart'
    as _i384;
import '../features/carts/data/sources/cart_local_data_source.dart' as _i454;
import '../features/carts/domain/repositories/cart_local_repository.dart'
    as _i118;
import '../features/carts/domain/usecases/local_cart/add_product_to_cart_use_case.dart'
    as _i851;
import '../features/carts/domain/usecases/local_cart/clear_cart_use_case.dart'
    as _i395;
import '../features/carts/domain/usecases/local_cart/decrement_cart_item_use_case.dart'
    as _i419;
import '../features/carts/domain/usecases/local_cart/get_cart_items_use_case.dart'
    as _i759;
import '../features/carts/domain/usecases/local_cart/get_cart_total_quantity_use_case.dart'
    as _i203;
import '../features/carts/domain/usecases/local_cart/increment_cart_item_use_case.dart'
    as _i684;
import '../features/carts/domain/usecases/local_cart/remove_cart_item_use_case.dart'
    as _i656;
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
  gh.lazySingleton<_i454.CartLocalDataSource>(
    () => _i454.CartLocalDataSource(),
  );
  gh.singleton<_i6.INetworkInfo>(() => _i927.NetworkInfoImpl.create());
  gh.lazySingleton<_i361.Dio>(() => apiModule.dio(gh<_i711.Openapi>()));
  gh.lazySingleton<_i138.Serializers>(
    () => apiModule.serializers(gh<_i711.Openapi>()),
  );
  gh.lazySingleton<_i118.CartLocalRepository>(
    () => _i384.CartLocalRepositoryImp(gh<_i454.CartLocalDataSource>()),
  );
  gh.factory<_i851.AddProductToCartUseCase>(
    () => _i851.AddProductToCartUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.factory<_i395.ClearCartUseCase>(
    () => _i395.ClearCartUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.factory<_i419.DecrementCartItemUseCase>(
    () => _i419.DecrementCartItemUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.factory<_i759.GetCartItemsUseCase>(
    () => _i759.GetCartItemsUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.factory<_i203.GetCartTotalQuantityUseCase>(
    () => _i203.GetCartTotalQuantityUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.factory<_i684.IncrementCartItemUseCase>(
    () => _i684.IncrementCartItemUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.factory<_i656.RemoveCartItemUseCase>(
    () => _i656.RemoveCartItemUseCase(gh<_i118.CartLocalRepository>()),
  );
  gh.singleton<_i927.ModelConverterHelper>(
    () => _i927.ModelConverterHelper(gh<_i138.Serializers>()),
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
