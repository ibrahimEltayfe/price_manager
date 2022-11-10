import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';

import '../../../../../core/utils/image_picker_helper.dart';
import '../../../../dashboard/domain/repositories/products_repository.dart';
import '../../../data/models/product_model.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final DashboardRepository dashboardRepository;
  final ImagePickerHelper imagePickerHelper;

  late ProductEntity product;

  StreamController<bool> buttonStateController = StreamController<bool>.broadcast()..sink.add(false);

  ProductDetailsBloc(this.dashboardRepository,this.imagePickerHelper) : super(ProductDetailsInitial()) {
    on<InitializeProductDetailsEvent>((event, emit) async{
      product = event.product;
      imagePickerHelper.init(img:event.product.image,isNetwork: true);
      emit(ProductDetailsSetInitialData());
    });

    on<UpdateProductDetailsEvent>((event, emit) async{
      emit(ProductDetailsLoading());

      ProductModel productModel = ProductModel(
        id: product.id,
        name: event.product.name,
        desc: event.product.desc,
        price: event.product.price,
        image: product.image,
        modifiedBy: dashboardRepository.userUID,
      );

      final results = await dashboardRepository.updateProduct(productModel,imagePickerHelper.image);
      results.fold(
           (failure) => emit(ProductDetailsError(failure.message)),
           (results) => emit(const ProductDetailsUpdated('product updated'))
      );

    });

    /*on<RemoveProductEvent>((event, emit) async{
      emit(ProductDetailsLoading());

      final results = await dashboardRepository.removeProduct(event.productId);
      results.fold(
         (failure) => emit(ProductDetailsError(failure.message)),
         (results) => emit(const ProductDetailsRemove('product removed'))
      );
    });*/
  }

  @override
  Future<void> close() {
    imagePickerHelper.dispose();
    buttonStateController.close();
    return super.close();
  }
}
