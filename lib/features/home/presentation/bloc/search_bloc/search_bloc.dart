import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../shared/entities/product_entity.dart';
import '../../../domain/repositories/products_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductsRepository productRepository;

  SearchBloc(this.productRepository) : super(SearchInitial()) {
    on<GetSearchResultsEvent>((event, emit) async{
      emit(SearchLoading());

      final results = await productRepository.searchForProducts(event.query);

      results.fold(
        (failure) => emit(SearchError(failure.message)),
        (data) => emit(SearchDataFetched(data))
      );
    });
  }
}
