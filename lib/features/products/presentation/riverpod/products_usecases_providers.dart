import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/di/injection.dart';
import 'package:future_solutions/features/products/domain/usecases/add_product_use_case/add_product_use_case.dart';
import 'package:future_solutions/features/products/domain/usecases/delete_product_use_case/delete_product_use_case.dart';
import 'package:future_solutions/features/products/domain/usecases/get_all_products_use_case/get_all_products_use_case.dart';
import 'package:future_solutions/features/products/domain/usecases/get_product_by_id_use_case/get_product_by_id_use_case.dart';
import 'package:future_solutions/features/products/domain/usecases/update_product_use_case/update_product_use_case.dart';

final getAllProductsUseCaseProvider = Provider<GetAllProductsUseCase>(
  (ref) => getIt<GetAllProductsUseCase>(),
);

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>(
  (ref) => getIt<GetProductByIdUseCase>(),
);

final addProductUseCaseProvider = Provider<AddProductUseCase>(
  (ref) => getIt<AddProductUseCase>(),
);

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>(
  (ref) => getIt<UpdateProductUseCase>(),
);

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>(
  (ref) => getIt<DeleteProductUseCase>(),
);
