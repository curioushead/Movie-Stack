import 'package:equatable/equatable.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/utils/enums.dart';

class MoviesState extends Equatable {
  final RequestStatus status;
  final String message;
  final List<Media> mainMovies;
  final List<Media> nowPlayingMovies;
  final Map<TimeWindow, List<Media>> trendingMovies;
  final List<Media> popularMovies;
  final List<Media> topRatedMovies;
  final RequestStatus popularMoviesStatus;
  final String popularMoviesMessage;
  final Map<TimeWindow, RequestStatus> trendingStatus;
  final Map<TimeWindow, String> trendingMessage;

  final TimeWindow selectedTimeWindow;

  const MoviesState({
    this.status = RequestStatus.loading,
    this.message = '',
    this.mainMovies = const [],
    this.nowPlayingMovies = const [],
    this.trendingMovies = const {
      TimeWindow.day: [],
      TimeWindow.week: [],
    },
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.popularMoviesStatus = RequestStatus.loading,
    this.popularMoviesMessage = '',
    this.trendingStatus = const {
      TimeWindow.day: RequestStatus.loading,
      TimeWindow.week: RequestStatus.loading,
    },
    this.trendingMessage = const {
      TimeWindow.day: '',
      TimeWindow.week: '',
    },
    this.selectedTimeWindow = TimeWindow.day,
  });

  MoviesState copyWith({
    RequestStatus? status,
    String? message,
    List<Media>? mainMovies,
    List<Media>? nowPlayingMovies,
    Map<TimeWindow, List<Media>>? trendingMovies,
    List<Media>? popularMovies,
    List<Media>? topRatedMovies,
    RequestStatus? popularMoviesStatus,
    String? popularMoviesMessage,
    Map<TimeWindow, RequestStatus>? trendingStatus,
    Map<TimeWindow, String>? trendingMessage,
    TimeWindow? selectedTimeWindow,
  }) {
    return MoviesState(
      status: status ?? this.status,
      message: message ?? this.message,
      mainMovies: mainMovies ?? this.mainMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      popularMoviesStatus: popularMoviesStatus ?? this.popularMoviesStatus,
      popularMoviesMessage: popularMoviesMessage ?? this.popularMoviesMessage,
      trendingStatus: trendingStatus ?? this.trendingStatus,
      trendingMessage: trendingMessage ?? this.trendingMessage,
      selectedTimeWindow: selectedTimeWindow ?? this.selectedTimeWindow,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        mainMovies,
        nowPlayingMovies,
        trendingMovies,
        popularMovies,
        topRatedMovies,
        popularMoviesStatus,
        popularMoviesMessage,
        trendingStatus,
        trendingMessage,
        selectedTimeWindow,
      ];
}
