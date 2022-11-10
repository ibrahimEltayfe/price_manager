import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:price_manager/core/utils/image_picker_helper.dart';
import 'package:price_manager/features/dashboard/domain/repositories/products_repository.dart';
import 'package:price_manager/features/home/data/models/product_model.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  DashboardRepository dashboardRepository;
  ImagePickerHelper imagePickerHelper;

  AddProductBloc(this.dashboardRepository,this.imagePickerHelper) : super(AddProductInitial()) {

    on<InitializeProductEvent>((event, emit){
      imagePickerHelper.init();
    });

    on<SaveProductEvent>((event, emit) async{
      emit(AddProductLoading());

      ProductModel productModel = ProductModel(
        name: event.name,
        desc: event.desc,
        price: event.price,
        createdBy: dashboardRepository.userUID,
      );

      final results = await dashboardRepository.addProduct(productModel,File(imagePickerHelper.image??''));
      results.fold(
         (failure) => emit(AddProductError(failure.message)),
         (results) => emit(AddProductDataSaved())
      );
    });

  }

  @override
  Future<void> close() {
    imagePickerHelper.dispose();
    return super.close();
  }
}

