import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:future_solutions/features/carts/domain/repositories/cart_local_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/local_cart/params/add_product_to_cart_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddProductToCartUseCase
    extends UseCase<List<CartItemEntity>, AddProductToCartParams> {
  AddProductToCartUseCase(this.repository);

  final CartLocalRepository repository;

  @override
  Future<Either> call(AddProductToCartParams params) =>
      repository.addProduct(params.product);
}
