import 'package:equatable/equatable.dart';
import 'package:movie_stack/core/utils/enums.dart';

class TrendingMoviesParameters extends Equatable {
  final TimeWindow timeWindow;

  const TrendingMoviesParameters({required this.timeWindow});

  @override
  List<Object> get props => [timeWindow];
}
