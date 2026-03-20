import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:future_solutions/features/carts/presentation/riverpod/local_cart_usecases_providers.dart';

final cartItemsProvider =
    AsyncNotifierProvider.autoDispose<CartItemsNotifier, List<CartItemEntity>>(
      CartItemsNotifier.new,
    );

final cartTotalQuantityProvider = Provider.autoDispose<int>((ref) {
  final itemsAsync = ref.watch(cartItemsProvider);
  return itemsAsync.asData?.value.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      ) ??
      0;
});

class CartItemsNotifier extends AsyncNotifier<List<CartItemEntity>> {
  @override
  Future<List<CartItemEntity>> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<CartItemEntity>> _fetch() async {
    final useCase = ref.read(getCartItemsUseCaseProvider);
    final result = await useCase(const NoParams());

    return result.fold((left) => throw _mapError(left), (right) => right);
  }

  Failure _mapError(Object error) {
    if (error is Failure) return error;
    return UnknownFailure(error.toString());
  }
}
