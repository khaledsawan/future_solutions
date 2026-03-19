import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:future_solutions/features/carts/domain/usecases/params.dart';
// ignore: unused_import
import 'package:openapi/openapi.dart';

// GENERATED START - carts - repository_interface
// This section is auto-generated. Do not edit manually.

abstract class CartsRepository {
  Future<Either<dynamic, Cart?>> addCart({required AddCartParams params});
  Future<Either<dynamic, void>> deleteCart({required DeleteCartParams params});
  Future<Either<dynamic, BuiltList<Cart>?>> getAllCarts();
  Future<Either<dynamic, Cart?>> getCartById({
    required GetCartByIdParams params,
  });
  Future<Either<dynamic, Cart?>> updateCart({required UpdateCartParams params});
}

// GENERATED END - carts - repository_interface
