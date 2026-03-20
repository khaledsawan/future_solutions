import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/features/products/domain/usecases/get_product_by_id_use_case/get_product_by_id_params.dart';
import 'package:future_solutions/features/products/presentation/riverpod/products_usecases_providers.dart';
import 'package:openapi/openapi.dart';

final productDetailProvider = FutureProvider.autoDispose.family<Product?, int>((
  ref,
  productId,
) async {
  final useCase = ref.read(getProductByIdUseCaseProvider);
  final result = await useCase(GetProductByIdParams(productId));

  return result.fold((left) => throw _mapError(left), (right) => right);
});

Failure _mapError(Object error) {
  if (error is Failure) return error;
  return UnknownFailure(error.toString());
}
