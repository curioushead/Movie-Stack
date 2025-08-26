import 'package:equatable/equatable.dart';
import 'package:movie_stack/core/utils/enums.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

/// Master event triggers fetching all four movie categories.
class GetMoviesEvent extends MoviesEvent {
  final String? region;

  const GetMoviesEvent({this.region});

  @override
  List<Object?> get props => [region];
}

class GetTrendingMoviesEvent extends MoviesEvent {
  final TimeWindow timeWindow;

  const GetTrendingMoviesEvent({required this.timeWindow});

  @override
  List<Object> get props => [timeWindow];
}
