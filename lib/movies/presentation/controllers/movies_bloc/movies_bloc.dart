import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/core/utils/enums.dart';
import 'package:movie_stack/movies/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_trending_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/trending_movies_parameters.dart';
import 'package:movie_stack/movies/presentation/controllers/movies_bloc/movies_event.dart';
import 'package:movie_stack/movies/presentation/controllers/movies_bloc/movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final GetTrendingMoviesUseCase _getTrendingMoviesUseCase;
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final GetTopRatedMoviesUseCase _getTopRatedMoviesUseCase;

  MoviesBloc(
      this._getNowPlayingMoviesUseCase,
      this._getTrendingMoviesUseCase,
      this._getPopularMoviesUseCase,
      this._getTopRatedMoviesUseCase,
      ) : super(const MoviesState()) {
    on<GetMoviesEvent>(_getMoviesHandler);
    on<GetTrendingMoviesEvent>(_getTrendingMoviesHandler);
  }

  /// Fetch all sections in parallel
  void _getMoviesHandler(
      GetMoviesEvent event, Emitter<MoviesState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading));

    final nowPlayingFuture = _getNowPlayingMoviesUseCase(
        NowPlayingMoviesParameters(region: event.region ?? 'IN'));
    final popularFuture = _getPopularMoviesUseCase(const NoParameters());
    final topRatedFuture = _getTopRatedMoviesUseCase(const NoParameters());
    final dailyTrendingFuture = _getTrendingMoviesUseCase(
        const TrendingMoviesParameters(timeWindow: TimeWindow.day));
    final weeklyTrendingFuture = _getTrendingMoviesUseCase(
        const TrendingMoviesParameters(timeWindow: TimeWindow.week));

    final results = await Future.wait([
      nowPlayingFuture,
      popularFuture,
      topRatedFuture,
      dailyTrendingFuture,
      weeklyTrendingFuture,
    ]);

    List<Media> nowPlayingMovies = [];
    List<Media> popularMovies = [];
    List<Media> topRatedMovies = [];
    Map<TimeWindow, List<Media>> trendingMovies = {};

    Map<TimeWindow, RequestStatus> trendingStatus = {
      TimeWindow.day: RequestStatus.loading,
      TimeWindow.week: RequestStatus.loading,
    };
    Map<TimeWindow, String> trendingMessage = {
      TimeWindow.day: '',
      TimeWindow.week: '',
    };

    String? firstErrorMessage;

    // Now Playing
    results[0].fold(
          (failure) => firstErrorMessage ??= failure.userMessage,
          (data) => nowPlayingMovies = data,
    );

    // Popular
    results[1].fold(
          (failure) => firstErrorMessage ??= failure.userMessage,
          (data) => popularMovies = data,
    );

    // Top Rated
    results[2].fold(
          (failure) => firstErrorMessage ??= failure.userMessage,
          (data) => topRatedMovies = data,
    );

    // Daily Trending
    results[3].fold(
          (failure) {
        firstErrorMessage ??= failure.userMessage;
        trendingMovies[TimeWindow.day] = [];
        trendingStatus[TimeWindow.day] = RequestStatus.error;
        trendingMessage[TimeWindow.day] = failure.userMessage;
      },
          (data) {
        trendingMovies[TimeWindow.day] = data;
        trendingStatus[TimeWindow.day] = RequestStatus.loaded;
      },
    );

    // Weekly Trending
    results[4].fold(
          (failure) {
        firstErrorMessage ??= failure.userMessage;
        trendingMovies[TimeWindow.week] = [];
        trendingStatus[TimeWindow.week] = RequestStatus.error;
        trendingMessage[TimeWindow.week] = failure.userMessage;
      },
          (data) {
        trendingMovies[TimeWindow.week] = data;
        trendingStatus[TimeWindow.week] = RequestStatus.loaded;
      },
    );

    if (firstErrorMessage != null) {
      emit(state.copyWith(
        status: RequestStatus.error,
        message: firstErrorMessage!,
        nowPlayingMovies: nowPlayingMovies,
        popularMovies: popularMovies,
        topRatedMovies: topRatedMovies,
        trendingMovies: trendingMovies,
        trendingStatus: trendingStatus,
        trendingMessage: trendingMessage,
      ));
    } else {
      emit(state.copyWith(
        status: RequestStatus.loaded,
        nowPlayingMovies: nowPlayingMovies,
        popularMovies: popularMovies,
        topRatedMovies: topRatedMovies,
        trendingMovies: trendingMovies,
        trendingStatus: trendingStatus,
        trendingMessage: trendingMessage,
      ));
    }
  }

  /// Fetch trending for a single timeWindow
  void _getTrendingMoviesHandler(
      GetTrendingMoviesEvent event, Emitter<MoviesState> emit) async {
    // Set only the requested timeWindow to loading
    final updatedStatus = Map<TimeWindow, RequestStatus>.from(state.trendingStatus)
      ..[event.timeWindow] = RequestStatus.loading;
    final updatedMessage = Map<TimeWindow, String>.from(state.trendingMessage)
      ..[event.timeWindow] = '';

    emit(state.copyWith(
      trendingStatus: updatedStatus,
      trendingMessage: updatedMessage,
    ));

    final result = await _getTrendingMoviesUseCase(
        TrendingMoviesParameters(timeWindow: event.timeWindow));

    result.fold(
          (failure) {
        final cachedMovies = state.trendingMovies[event.timeWindow] ?? [];

        if (cachedMovies.isNotEmpty) {
          // fallback to cached
          final status = Map<TimeWindow, RequestStatus>.from(updatedStatus)
            ..[event.timeWindow] = RequestStatus.loaded;
          final msg = Map<TimeWindow, String>.from(updatedMessage)
            ..[event.timeWindow] = 'Showing cached data.';

          emit(state.copyWith(
            trendingMovies: {
              ...state.trendingMovies,
              event.timeWindow: cachedMovies,
            },
            trendingStatus: status,
            trendingMessage: msg,
          ));
        } else {
          final status = Map<TimeWindow, RequestStatus>.from(updatedStatus)
            ..[event.timeWindow] = RequestStatus.error;
          final msg = Map<TimeWindow, String>.from(updatedMessage)
            ..[event.timeWindow] = failure.userMessage;

          emit(state.copyWith(
            trendingStatus: status,
            trendingMessage: msg,
          ));
        }
      },
          (movies) {
        final status = Map<TimeWindow, RequestStatus>.from(updatedStatus)
          ..[event.timeWindow] = RequestStatus.loaded;
        final msg = Map<TimeWindow, String>.from(updatedMessage)
          ..remove(event.timeWindow);

        emit(state.copyWith(
          trendingMovies: {
            ...state.trendingMovies,
            event.timeWindow: movies,
          },
          trendingStatus: status,
          trendingMessage: msg,
        ));
      },
    );
  }
}