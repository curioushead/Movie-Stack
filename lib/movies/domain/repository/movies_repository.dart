import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Media>>> getNowPlayingMovies({required String region});

  Future<Either<Failure, List<Media>>> getTrendingMovies(String timeWindow);

  Future<Either<Failure, MediaDetails>> getMovieDetails(int movieId);

  Future<Either<Failure, List<Media>>> getAllPopularMovies(int page);

  Future<Either<Failure, List<Media>>> getAllTopRatedMovies(int page);

  Future<Either<Failure, List<Media>>> getPopularMovies();

  Future<Either<Failure, List<Media>>> getTopRatedMovies();
}
