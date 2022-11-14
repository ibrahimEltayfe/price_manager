part of 'created_products_bloc.dart';

abstract class CreatedProductsEvent extends Equatable {
  const CreatedProductsEvent();

}

class LoadCreatedProductsEvent extends CreatedProductsEvent {
  const LoadCreatedProductsEvent();
  @override
  List<Object?> get props =>[];
}

class DeleteCreatedProductsEvent extends CreatedProductsEvent {
  final int index;
  const DeleteCreatedProductsEvent(this.index);

  @override
  List<Object?> get props =>[index];
}

