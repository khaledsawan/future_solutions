import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/entities/cart_item_entity.dart';
import 'package:future_solutions/features/carts/domain/repositories/cart_local_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearCartUseCase extends UseCase<List<CartItemEntity>, NoParams> {
  ClearCartUseCase(this.repository);

  final CartLocalRepository repository;

  @override
  Future<Either> call(NoParams params) => repository.clear();
}
