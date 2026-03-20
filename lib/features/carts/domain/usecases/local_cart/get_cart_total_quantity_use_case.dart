import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/repositories/cart_local_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartTotalQuantityUseCase extends UseCase<int, NoParams> {
  GetCartTotalQuantityUseCase(this.repository);

  final CartLocalRepository repository;

  @override
  Future<Either> call(NoParams params) => repository.getTotalQuantity();
}
