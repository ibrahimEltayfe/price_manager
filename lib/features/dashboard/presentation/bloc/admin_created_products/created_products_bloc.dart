import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_errors.dart';
import '../../../../home/data/data_sources/products_remote.dart' show productsLimit;
import '../../../../home/domain/entities/product_entity.dart';
import '../../../domain/repositories/products_repository.dart';
part 'created_products_event.dart';
part 'created_products_state.dart';

class CreatedProductsBloc extends Bloc<CreatedProductsEvent, CreatedProductsState> {
  final DashboardRepository dashboardRepository;

  bool isShowProducts = false;

  bool hasMore = true;
  bool isFirstFetch = true;
  List<ProductEntity> products = [];

  CreatedProductsBloc(this.dashboardRepository) : super(CreatedProductsInitial()){
    on<LoadCreatedProductsEvent>((event, emit) async{
      if(hasMore == false) {
        return;
      }

      emit(CreatedProductsLoading());

      final result = await dashboardRepository.getAdminProducts(isGetCreatedProducts: true);

      result.fold(
              (failure)=> emit(CreatedProductsError(failure.message)),

              (results){
            if(isFirstFetch && results.isEmpty){
              emit(const CreatedProductsError(AppErrors.productListIsEmpty));
            }

            isFirstFetch = false;

            if(results.length < productsLimit){
              hasMore = false;
            }

            products.addAll(results);
            emit(CreatedProductsDataFetched());

          }
      );

    },transformer: droppable());

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
}
