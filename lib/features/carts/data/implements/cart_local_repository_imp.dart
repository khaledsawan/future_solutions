import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/error/failure.dart';
import 'package:future_solutions/features/carts/data/models/local_cart_item_model.dart';
import 'package:future_solutions/features/carts/data/sources/cart_local_data_source.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:future_solutions/features/carts/domain/repositories/cart_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

@LazySingleton(as: CartLocalRepository)
class CartLocalRepositoryImp implements CartLocalRepository {
  CartLocalRepositoryImp(this.localDataSource);

  final CartLocalDataSource localDataSource;

  @override
  Future<Either<dynamic, List<CartItemEntity>>> getItems() async {
    try {
      final items = await localDataSource.getItems();
      return Right(
        items.map((item) => item.toEntity()).toList(growable: false),
      );
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<CartItemEntity>>> addProduct(
    Product product,
  ) async {
    try {
      final productId = product.id;
      if (productId == null) {
        return const Left(
          ValidationFailure(
            message: 'Product id is required for cart operations',
          ),
        );
      }

      final items = await localDataSource.getItems();
      final index = items.indexWhere((item) => item.productId == productId);

      if (index == -1) {
        items.add(
          LocalCartItemModel(
            productId: productId,
            title: product.title ?? '',
            price: product.price ?? 0,
            image: product.image ?? '',
            category: product.category ?? '',
            quantity: 1,
          ),
        );
      } else {
        final existing = items[index];
        items[index] = LocalCartItemModel(
          productId: existing.productId,
          title: existing.title,
          price: existing.price,
          image: existing.image,
          category: existing.category,
          quantity: existing.quantity + 1,
        );
      }

      await localDataSource.saveItems(items);
      return Right(
        items.map((item) => item.toEntity()).toList(growable: false),
      );
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<CartItemEntity>>> increment(int productId) async {
    try {
      final items = await localDataSource.getItems();
      final index = items.indexWhere((item) => item.productId == productId);
      if (index == -1) {
        return const Left(ValidationFailure(message: 'Cart item not found'));
      }

      final existing = items[index];
      items[index] = LocalCartItemModel(
        productId: existing.productId,
        title: existing.title,
        price: existing.price,
        image: existing.image,
        category: existing.category,
        quantity: existing.quantity + 1,
      );

      await localDataSource.saveItems(items);
      return Right(
        items.map((item) => item.toEntity()).toList(growable: false),
      );
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<CartItemEntity>>> decrement(int productId) async {
    try {
      final items = await localDataSource.getItems();
      final index = items.indexWhere((item) => item.productId == productId);
      if (index == -1) {
        return const Left(ValidationFailure(message: 'Cart item not found'));
      }

      final existing = items[index];
      if (existing.quantity <= 1) {
        items.removeAt(index);
      } else {
        items[index] = LocalCartItemModel(
          productId: existing.productId,
          title: existing.title,
          price: existing.price,
          image: existing.image,
          category: existing.category,
          quantity: existing.quantity - 1,
        );
      }

      await localDataSource.saveItems(items);
      return Right(
        items.map((item) => item.toEntity()).toList(growable: false),
      );
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<CartItemEntity>>> remove(int productId) async {
    try {
      final items = await localDataSource.getItems();
      items.removeWhere((item) => item.productId == productId);

      await localDataSource.saveItems(items);
      return Right(
        items.map((item) => item.toEntity()).toList(growable: false),
      );
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<CartItemEntity>>> clear() async {
    try {
      await localDataSource.saveItems(const []);
      return const Right([]);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<dynamic, int>> getTotalQuantity() async {
    try {
      final items = await localDataSource.getItems();
      final total = items.fold<int>(0, (sum, item) => sum + item.quantity);
      return Right(total);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }
}
