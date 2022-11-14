import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:price_manager/core/constants/app_colors.dart';
import '../../../../../core/constants/app_errors.dart';
import '../../../../home/data/data_sources/products_remote.dart' show productsLimit;
import '../../../../shared/entities/product_entity.dart';
import '../../../domain/repositories/products_repository.dart';
part 'created_products_event.dart';
part 'created_products_state.dart';

class CreatedProductsBloc extends Bloc<CreatedProductsEvent, CreatedProductsState> {
  final DashboardRepository dashboardRepository;

  bool isShowProducts = false;

  bool hasMore = true;
  bool isFirstFetch = true;
  List<ProductEntity> products = [];

  StreamController<List<ProductEntity>> productsController = StreamController<List<ProductEntity>>.broadcast();

  CreatedProductsBloc(this.dashboardRepository) : super(CreatedProductsInitial()){
    on<LoadCreatedProductsEvent>((event, emit) async{
      if(hasMore == false) {
        return;
      }

      emit(CreatedProductsLoading());

      final result = await dashboardRepository.getAdminProducts(
          isGetCreatedProducts: true,
          isFirstFetch: isFirstFetch
      );

      result.fold(
           (failure)=> emit(CreatedProductsError(failure.message)),

           (results){
            if(isFirstFetch && results.isEmpty){
              emit(const CreatedProductsError(AppErrors.productListIsEmpty));
              return;
            }

            isFirstFetch = false;

            if(results.length < productsLimit){
              hasMore = false;
            }

            products.addAll(results);
            productsController.sink.add(products);
            emit(CreatedProductsDataFetched());

          }
      );

    },transformer: droppable());

    on<DeleteCreatedProductsEvent>((event, emit) async{
      final results = await dashboardRepository.removeProduct(
        products[event.index].id??'',
        products[event.index].image??''
      );

      results.fold(
        (failure)=>emit(ProductDeletedError(failure.message)),
        (_){
            products.removeAt(event.index);
            productsController.sink.add(products);
            emit(ProductDeleted());
          }
      );
    });

  }
  bool handleScrollPagination({
      required ScrollNotification scrollNotification,
      required double subtractedTriggerHeight,
  }){
    if (scrollNotification.metrics.pixels
        >= scrollNotification.metrics.maxScrollExtent - subtractedTriggerHeight) {
      if (hasMore) {
        add(const LoadCreatedProductsEvent());
      }
      return true;
    }
    return false;
  }

  void refresh(){
    hasMore = true;
    isFirstFetch = true;
    products = [];
    add(const LoadCreatedProductsEvent());
  }

  @override
  Future<void> close() {
    productsController.close();
    return super.close();
  }
}
