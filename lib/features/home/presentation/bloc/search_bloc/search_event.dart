part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class GetSearchResultsEvent extends SearchEvent {
  final String query;
  const GetSearchResultsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

