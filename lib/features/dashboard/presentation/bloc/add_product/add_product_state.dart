part of 'add_product_bloc.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();
  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductDataSaved extends AddProductState {}

class AddProductError extends AddProductState {
  final String message;
  const AddProductError(this.message);

  @override
  List<Object> get props => [message];
}