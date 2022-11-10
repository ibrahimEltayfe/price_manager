part of 'modified_products_bloc.dart';

abstract class ModifiedProductsEvent extends Equatable {
  const ModifiedProductsEvent();
}

class LoadModifiedProductsEvent extends ModifiedProductsEvent {
  const LoadModifiedProductsEvent();

  @override
  List<Object?> get props => [];
}

