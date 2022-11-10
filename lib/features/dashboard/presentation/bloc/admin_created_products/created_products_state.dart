part of 'created_products_bloc.dart';

abstract class CreatedProductsState extends Equatable {
  const CreatedProductsState();
}

class CreatedProductsInitial extends CreatedProductsState {
  @override
  List<Object> get props => [];
}

class CreatedProductsLoading extends CreatedProductsState {
  @override
  List<Object> get props => [];
}

class CreatedProductsDataFetched extends CreatedProductsState {
  @override
  List<Object> get props => [];
}

class CreatedProductsError extends CreatedProductsState {
  final String message;
  const CreatedProductsError(this.message);

  @override
  List<Object> get props => [message];
}
