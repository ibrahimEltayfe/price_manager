part of 'created_products_bloc.dart';

abstract class CreatedProductsState extends Equatable {
  const CreatedProductsState();
  @override
  List<Object> get props => [];
}

class CreatedProductsInitial extends CreatedProductsState {}

class CreatedProductsLoading extends CreatedProductsState {}

class CreatedProductsDataFetched extends CreatedProductsState {}

class ProductDeleted extends CreatedProductsState {}

class ProductDeletedError extends CreatedProductsState {
  final String message;
  const ProductDeletedError(this.message);

  @override
  List<Object> get props => [message];
}

class CreatedProductsError extends CreatedProductsState {
  final String message;
  const CreatedProductsError(this.message);

  @override
  List<Object> get props => [message];
}
