import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/params/add_product_to_cart_params.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/params/cart_item_product_id_params.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/carts_list_provider.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/local_cart_usecases_providers.dart';
import 'package:openapi/openapi.dart';

final cartActionsControllerProvider =
    NotifierProvider<CartActionsController, AsyncValue<void>>(
      CartActionsController.new,
    );

class CartActionResult {
  const CartActionResult.success(this.messageKey, {this.namedArgs = const {}})
    : failure = null,
      isSuccess = true;

  const CartActionResult.failure(this.failure)
    : messageKey = null,
      namedArgs = const {},
      isSuccess = false;

  final bool isSuccess;
  final String? messageKey;
  final Map<String, String> namedArgs;
  final Failure? failure;
}

class CartActionsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<CartActionResult> addProduct(Product product) async {
    state = const AsyncLoading();
    final useCase = ref.read(addProductToCartUseCaseProvider);
    final result = await useCase(AddProductToCartParams(product));

    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return CartActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.invalidate(cartItemsProvider);
        return const CartActionResult.success(
          'products.messages.add_to_cart_success',
        );
      },
    );
  }

  Future<CartActionResult> increment(int productId) async {
    state = const AsyncLoading();
    final useCase = ref.read(incrementCartItemUseCaseProvider);
    final result = await useCase(CartItemProductIdParams(productId));

    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return CartActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.invalidate(cartItemsProvider);
        return const CartActionResult.success('carts.messages.update_success');
      },
    );
  }

  Future<CartActionResult> decrement(int productId) async {
    state = const AsyncLoading();
    final useCase = ref.read(decrementCartItemUseCaseProvider);
    final result = await useCase(CartItemProductIdParams(productId));

    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return CartActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.invalidate(cartItemsProvider);
        return const CartActionResult.success('carts.messages.update_success');
      },
    );
  }

  Future<CartActionResult> remove(int productId) async {
    state = const AsyncLoading();
    final useCase = ref.read(removeCartItemUseCaseProvider);
    final result = await useCase(CartItemProductIdParams(productId));

    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return CartActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.invalidate(cartItemsProvider);
        return const CartActionResult.success('carts.messages.remove_success');
      },
    );
  }

  Future<CartActionResult> clear() async {
    state = const AsyncLoading();
    final useCase = ref.read(clearCartUseCaseProvider);
    final result = await useCase(const NoParams());

    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return CartActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.invalidate(cartItemsProvider);
        return const CartActionResult.success('carts.messages.clear_success');
      },
    );
  }

  Failure _mapError(Object error) {
    if (error is Failure) return error;
    return UnknownFailure(error.toString());
  }

  CartActionResult _disposedResult() {
    return const CartActionResult.failure(
      UnknownFailure('Provider was disposed before completing the action'),
    );
  }
}
