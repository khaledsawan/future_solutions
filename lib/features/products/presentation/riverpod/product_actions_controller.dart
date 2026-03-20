import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/params/add_product_to_cart_params.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/carts_list_provider.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/local_cart_usecases_providers.dart';
import 'package:future_solutions/features/products/domain/usecases/delete_product_use_case/delete_product_params.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_detail_provider.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_form_controller.dart';
import 'package:future_solutions/features/products/presentation/riverpod/products_list_provider.dart';
import 'package:future_solutions/features/products/presentation/riverpod/products_usecases_providers.dart';
import 'package:openapi/openapi.dart';

final productActionsControllerProvider =
    NotifierProvider<ProductActionsController, AsyncValue<void>>(
      ProductActionsController.new,
    );

class ProductActionResult {
  const ProductActionResult.success(
    this.messageKey, {
    this.namedArgs = const {},
  }) : failure = null,
       isSuccess = true;

  const ProductActionResult.failure(this.failure)
    : messageKey = null,
      namedArgs = const {},
      isSuccess = false;

  final bool isSuccess;
  final String? messageKey;
  final Map<String, String> namedArgs;
  final Failure? failure;
}

class ProductActionsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<ProductActionResult> addProduct(Product product) async {
    state = const AsyncLoading();
    final useCase = ref.read(addProductUseCaseProvider);
    final result = await useCase(ProductFormController.toAddParams(product));
    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return ProductActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        if (right != null) {
          ref.read(productsListProvider.notifier).upsertProduct(right);
        } else {
          ref.invalidate(productsListProvider);
        }
        return const ProductActionResult.success(
          'products.messages.add_success',
        );
      },
    );
  }

  Future<ProductActionResult> updateProduct({
    required int id,
    required Product product,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(updateProductUseCaseProvider);
    final result = await useCase(
      ProductFormController.toUpdateParams(id: id, product: product),
    );
    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return ProductActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        if (right != null) {
          ref.read(productsListProvider.notifier).upsertProduct(right);
        } else {
          ref.invalidate(productsListProvider);
        }
        ref.invalidate(productDetailProvider(id));
        return const ProductActionResult.success(
          'products.messages.update_success',
        );
      },
    );
  }

  Future<ProductActionResult> deleteProduct(int id) async {
    state = const AsyncLoading();
    final useCase = ref.read(deleteProductUseCaseProvider);
    final result = await useCase(DeleteProductParams(id));
    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return ProductActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.read(productsListProvider.notifier).removeProductById(id);
        ref.invalidate(productDetailProvider(id));
        return const ProductActionResult.success(
          'products.messages.delete_success',
        );
      },
    );
  }

  Future<ProductActionResult> addToCart(Product product) async {
    final productId = product.id;
    final title = (product.title ?? '').trim();

    if (productId == null) {
      return const ProductActionResult.failure(
        ValidationFailure(message: 'Product ID is required'),
      );
    }

    state = const AsyncLoading();
    final addUseCase = ref.read(addProductToCartUseCaseProvider);
    final result = await addUseCase(AddProductToCartParams(product));

    if (!ref.mounted) return _disposedResult();

    return result.fold(
      (left) {
        final failure = _mapError(left);
        state = AsyncError(failure, StackTrace.current);
        return ProductActionResult.failure(failure);
      },
      (right) {
        state = const AsyncData(null);
        ref.invalidate(cartItemsProvider);
        return ProductActionResult.success(
          'products.messages.add_to_cart_success',
          namedArgs: {'title': title},
        );
      },
    );
  }

  Failure _mapError(Object error) {
    if (error is Failure) return error;
    return UnknownFailure(error.toString());
  }

  ProductActionResult _disposedResult() {
    return const ProductActionResult.failure(
      UnknownFailure('Provider was disposed before completing the action'),
    );
  }
}
