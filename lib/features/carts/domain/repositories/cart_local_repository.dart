import 'package:dartz/dartz.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:openapi/openapi.dart';

abstract class CartLocalRepository {
  Future<Either<dynamic, List<CartItemEntity>>> getItems();
  Future<Either<dynamic, List<CartItemEntity>>> addProduct(Product product);
  Future<Either<dynamic, List<CartItemEntity>>> increment(int productId);
  Future<Either<dynamic, List<CartItemEntity>>> decrement(int productId);
  Future<Either<dynamic, List<CartItemEntity>>> remove(int productId);
  Future<Either<dynamic, List<CartItemEntity>>> clear();
  Future<Either<dynamic, int>> getTotalQuantity();
}
