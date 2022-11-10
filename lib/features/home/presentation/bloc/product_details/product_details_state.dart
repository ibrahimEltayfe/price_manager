part of 'product_details_bloc.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
}

class ProductDetailsInitial extends ProductDetailsState {
  @override
  List<Object> get props => [];
}

class ProductDetailsSetInitialData extends ProductDetailsState {

  @override
  List<Object> get props => [];
}

class ProductDetailsLoading extends ProductDetailsState {
  @override
  List<Object> get props => [];
}

class ProductDetailsUpdated extends ProductDetailsState {
  final String message;
  const ProductDetailsUpdated(this.message);

  @override
  List<Object> get props => [message];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  const ProductDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
