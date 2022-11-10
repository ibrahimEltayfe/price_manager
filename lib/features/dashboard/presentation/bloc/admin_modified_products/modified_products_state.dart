part of 'modified_products_bloc.dart';

abstract class ModifiedProductsState extends Equatable {
  const ModifiedProductsState();
}

class ModifiedProductsInitial extends ModifiedProductsState {
  @override
  List<Object> get props => [];
}

class ModifiedProductsLoading extends ModifiedProductsState {
  @override
  List<Object> get props => [];
}

class ModifiedProductsDataFetched extends ModifiedProductsState {
  @override
  List<Object> get props => [];
}

class ModifiedProductsError extends ModifiedProductsState {
  final String message;
  const ModifiedProductsError(this.message);

  @override
  List<Object> get props => [message];
}
