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
  StreamController<String?> productDateInfoController = StreamController<String>();

  ProductDetailsBloc(this.dashboardRepository,this.imagePickerHelper) : super(ProductDetailsInitial()) {
    on<InitializeProductDetailsEvent>((event, emit) async{
      imagePickerHelper.init(img:product.image,isNetwork: true);
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

      product = productModel;

      final results = await dashboardRepository.updateProduct(productModel,imagePickerHelper.image);
      results.fold(
           (failure) => emit(ProductDetailsError(failure.message)),
           (results){
             buttonStateController.sink.add(false);
             getProductCreatedOrModifiedData();
             emit(const ProductDetailsUpdated('product updated'));
           }
      );

    });
  }

  dateFormatStyle(date){
    return '${date.hour}:${date.minute} - ${date.year}-${date.month}-${date.day} ';
  }

  Future<void> getProductCreatedOrModifiedData() async{
    String text = '';
    DateTime date;

      if(product.modifiedBy == null || product.modifiedBy!.isEmpty){
        final results = await dashboardRepository.getUserName(product.createdBy??'');

        results.fold(
          (failure){
            productDateInfoController.sink.add(failure.message);
          },
          (userName){

            date =  product.createdAt!.toDate();
            text = " تم الانشاء بواسطة " + (userName??'...') + "  فى  " + dateFormatStyle(date);
            productDateInfoController.sink.add(text);
          }
        );

      }else{
        final results = await dashboardRepository.getUserName(product.modifiedBy??'');

        results.fold(
            (failure){
              productDateInfoController.sink.add(failure.message);
            },
            (userName){
              date =  product.modifiedAt!.toDate();
              text = " تم التعديل بواسطة " + (userName??'...') + "  فى  " + dateFormatStyle(date);
              productDateInfoController.sink.add(text);
            }
        );

      }
  }

  @override
  Future<void> close() {
    imagePickerHelper.dispose();
    buttonStateController.close();
    return super.close();
  }
}
