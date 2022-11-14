part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchDataFetched extends SearchState {
  final List<ProductEntity> searchResults;

  const SearchDataFetched(this.searchResults);
  @override
  List<Object> get props => [searchResults];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
