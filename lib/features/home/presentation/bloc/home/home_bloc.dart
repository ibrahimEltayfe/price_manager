import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:price_manager/core/constants/app_errors.dart';
import 'package:price_manager/features/home/data/data_sources/products_remote.dart';
import 'package:price_manager/features/home/data/models/product_model.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/products_repository.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductsRepository productsRepository;

  bool hasMore = true;
  bool isFirstFetch = true;
  List<ProductEntity> products = [];

  HomeBloc(this.productsRepository) : super(HomeInitial()) {

    on<HomeLoadDataEvent>((event, emit) async{
      //no more data to fetch
       if(hasMore == false) {
         return;
       }

       emit(HomeLoading());
       //await Future.delayed(const Duration(milliseconds: 2500));
       final result = await productsRepository.getAllProducts(isFirstFetch);

       result.fold(
        (failure)=> emit(HomeError(failure.message)),

        (results){
            if(isFirstFetch && results.isEmpty){
              emit(const HomeError(AppErrors.productListIsEmpty));
            }

             isFirstFetch = false;

             if(results.length < productsLimit){
               hasMore = false;
             }

            products.addAll(results);
            emit(HomeDataFetched());

           }
       );

    },transformer: droppable());

  }

  bool handleScrollPagination(
     ScrollNotification scrollNotification,
     double subtractedTriggerHeight
  ){
    if (scrollNotification.metrics.pixels
        >= scrollNotification.metrics.maxScrollExtent - subtractedTriggerHeight) {
      if (hasMore) {
        add(HomeLoadDataEvent());
      }
      return true;
    }
    return false;
  }

  void reset(){
    hasMore = true;
    isFirstFetch = true;
    products = [];
  }
}
