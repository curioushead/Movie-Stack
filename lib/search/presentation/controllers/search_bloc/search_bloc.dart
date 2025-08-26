import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart'; // <-- correct debounce helper
import 'package:movie_stack/core/utils/enums.dart';
import 'package:movie_stack/search/domain/entities/search_result_item.dart';
import 'package:movie_stack/search/domain/repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

const _debounceDuration = Duration(milliseconds: 500);

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;

  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchTextChanged>(
      _onSearchTextChanged,
      transformer: (events, mapper) =>
          events.debounce(_debounceDuration).switchMap(mapper),
    );
  }

  Future<void> _onSearchTextChanged(
      SearchTextChanged event,
      Emitter<SearchState> emit,
      ) async {
    final query = event.query.trim();

    // If user cleared the field, return to empty state immediately
    if (query.isEmpty) {
      emit(state.copyWith(
        status: SearchRequestStatus.empty,
        searchResults: [],
        message: '',
      ));
      return;
    }

    // Show loading (you could keep previous results if you prefer)
    emit(state.copyWith(status: SearchRequestStatus.loading));

    // Call repository (returns Either<Failure, List<SearchResultItem>>)
    final result = await _repository.search(query);

    result.fold(
          (failure) {
        // Failure path
        emit(state.copyWith(
          status: SearchRequestStatus.error,
          message: failure.message,
          searchResults: [],
        ));
      },
          (items) {
        // Success path
        if (items.isEmpty) {
          emit(state.copyWith(
            status: SearchRequestStatus.noResults,
            searchResults: [],
            message: '',
          ));
        } else {
          emit(state.copyWith(
            status: SearchRequestStatus.loaded,
            searchResults: items,
            message: '',
          ));
        }
      },
    );
  }
}
