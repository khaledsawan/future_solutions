import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/presentation/riverpod/products_usecases_providers.dart';
import 'package:openapi/openapi.dart';

final productsListProvider =
    AsyncNotifierProvider.autoDispose<ProductsListNotifier, List<Product>>(
      ProductsListNotifier.new,
    );

class ProductsListNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<Product>> _fetch() async {
    final useCase = ref.read(getAllProductsUseCaseProvider);
    final result = await useCase(const NoParams());

    return result.fold(
      (left) => throw _mapError(left),
      (right) => right?.toList() ?? <Product>[],
    );
  }

  void upsertProduct(Product product) {
    final currentList = state.asData?.value;
    if (currentList == null) return;

    final mutable = List<Product>.from(currentList);
    final index = mutable.indexWhere((element) => element.id == product.id);
    if (index == -1) {
      mutable.insert(0, product);
    } else {
      mutable[index] = product;
    }
    state = AsyncData(List<Product>.unmodifiable(mutable));
  }

  void removeProductById(int id) {
    final currentList = state.asData?.value;
    if (currentList == null) return;

    state = AsyncData(
      List<Product>.unmodifiable(
        currentList.where((product) => product.id != id),
      ),
    );
  }

  Failure _mapError(Object error) {
    if (error is Failure) return error;
    return UnknownFailure(error.toString());
  }
}
