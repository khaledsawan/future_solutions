import 'package:equatable/equatable.dart';
import 'package:future_solutions/core/error/failure.dart';

abstract class BaseState<T> extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class BaseInitial<T> extends BaseState<T> {
  const BaseInitial();
}

class BaseLoading<T> extends BaseState<T> {
  const BaseLoading();
}

class BaseLoaded<T> extends BaseState<T> {
  const BaseLoaded(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

class BaseError<T> extends BaseState<T> {
  const BaseError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
