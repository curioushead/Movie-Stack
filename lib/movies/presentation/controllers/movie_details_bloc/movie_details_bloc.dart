import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/core/utils/enums.dart';
import 'package:movie_stack/movies/domain/usecases/get_movie_details_usecase.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMoviesDetailsUseCase _getMoviesDetailsUseCase;

  MovieDetailsBloc(this._getMoviesDetailsUseCase)
      : super(const MovieDetailsState()) {
    on<GetMovieDetailsEvent>(_getMovieDetails);
  }

  Future<void> _getMovieDetails(
      GetMovieDetailsEvent event, Emitter<MovieDetailsState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
      ),
    );
    final result = await _getMoviesDetailsUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.error,
          message: failure.message,
        ),
      ),
      (movieDetails) => emit(
        state.copyWith(
          status: RequestStatus.loaded,
          movieDetails: movieDetails,
        ),
      ),
    );
  }
}
