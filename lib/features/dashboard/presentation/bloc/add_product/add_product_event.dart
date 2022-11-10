part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();
}

class InitializeProductEvent extends AddProductEvent {
  const InitializeProductEvent();

  @override
  List<Object?> get props => [];
}

class SaveProductEvent extends AddProductEvent {
  final String name;
  final String desc;
  final String price;
  const SaveProductEvent({required this.name,required this.desc,required this.price});

  @override
  List<Object?> get props => [name,desc,price];
}


