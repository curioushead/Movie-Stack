part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchTextChanged extends SearchEvent {
  final String query;

  const SearchTextChanged(this.query);

  @override
  List<Object> get props => [query];
}
