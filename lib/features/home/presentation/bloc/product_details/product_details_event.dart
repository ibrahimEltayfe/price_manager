part of 'product_details_bloc.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();
}

class UpdateProductDetailsEvent extends ProductDetailsEvent {
  final ProductEntity product;
  const UpdateProductDetailsEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class InitializeProductDetailsEvent extends ProductDetailsEvent {
  final ProductEntity product;
  const InitializeProductDetailsEvent(this.product);

  @override
  List<Object?> get props => [product];
}
