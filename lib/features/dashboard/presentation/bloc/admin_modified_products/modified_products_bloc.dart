import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_errors.dart';
import '../../../../home/data/data_sources/products_remote.dart' show productsLimit;
import '../../../../shared/entities/product_entity.dart';
import '../../../domain/repositories/products_repository.dart';
part 'modified_products_event.dart';
part 'modified_products_state.dart';

class ModifiedProductsBloc extends Bloc<ModifiedProductsEvent, ModifiedProductsState> {
  final DashboardRepository dashboardRepository;

  bool isShowProducts = false;

  bool hasMore = true;
  bool isFirstFetch = true;
  List<ProductEntity> products = [];

  ModifiedProductsBloc(this.dashboardRepository) : super(ModifiedProductsInitial()) {
    on<LoadModifiedProductsEvent>((event, emit) async{
      if(hasMore == false) {
        return;
      }

      emit(ModifiedProductsLoading());

      final result = await dashboardRepository.getAdminProducts(
          isGetCreatedProducts: false,
          isFirstFetch: isFirstFetch
      );

      result.fold(
       (failure)=> emit(ModifiedProductsError(failure.message)),

        (results){
            if(isFirstFetch && results.isEmpty){
              emit(const ModifiedProductsError(AppErrors.productListIsEmpty));
              return;
            }

            isFirstFetch = false;

            if(results.length < productsLimit){
              hasMore = false;
            }

            products.addAll(results);
            emit(ModifiedProductsDataFetched());
          }
      );

    }
    ,transformer: droppable()
    );
  }

  bool handleScrollPagination({
    required ScrollNotification scrollNotification,
    required double subtractedTriggerHeight,
  }){
    if (scrollNotification.metrics.pixels
        >= scrollNotification.metrics.maxScrollExtent - subtractedTriggerHeight) {
      if (hasMore) {
        add(const LoadModifiedProductsEvent());
      }
      return true;
    }
    return false;
  }

  void refresh(){
    hasMore = true;
    isFirstFetch = true;
    products = [];
    add(const LoadModifiedProductsEvent());
  }
}
