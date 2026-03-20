import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/di/injection.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/add_product_to_cart_use_case.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/clear_cart_use_case.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/decrement_cart_item_use_case.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/get_cart_items_use_case.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/get_cart_total_quantity_use_case.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/increment_cart_item_use_case.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/remove_cart_item_use_case.dart';

final getCartItemsUseCaseProvider = Provider<GetCartItemsUseCase>(
  (ref) => getIt<GetCartItemsUseCase>(),
);

final getCartTotalQuantityUseCaseProvider =
    Provider<GetCartTotalQuantityUseCase>(
      (ref) => getIt<GetCartTotalQuantityUseCase>(),
    );

final addProductToCartUseCaseProvider = Provider<AddProductToCartUseCase>(
  (ref) => getIt<AddProductToCartUseCase>(),
);

final incrementCartItemUseCaseProvider = Provider<IncrementCartItemUseCase>(
  (ref) => getIt<IncrementCartItemUseCase>(),
);

final decrementCartItemUseCaseProvider = Provider<DecrementCartItemUseCase>(
  (ref) => getIt<DecrementCartItemUseCase>(),
);

final removeCartItemUseCaseProvider = Provider<RemoveCartItemUseCase>(
  (ref) => getIt<RemoveCartItemUseCase>(),
);

final clearCartUseCaseProvider = Provider<ClearCartUseCase>(
  (ref) => getIt<ClearCartUseCase>(),
);
