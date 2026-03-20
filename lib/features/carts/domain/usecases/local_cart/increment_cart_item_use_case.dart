import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:future_solutions/features/carts/domain/repositories/cart_local_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/params/cart_item_product_id_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncrementCartItemUseCase
    extends UseCase<List<CartItemEntity>, CartItemProductIdParams> {
  IncrementCartItemUseCase(this.repository);

  final CartLocalRepository repository;

  @override
  Future<Either> call(CartItemProductIdParams params) =>
      repository.increment(params.productId);
}
