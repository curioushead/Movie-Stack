import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';
import 'package:movie_stack/movies/domain/usecases/trending_movies_parameters.dart';

class GetTrendingMoviesUseCase
    extends BaseUseCase<List<Media>, TrendingMoviesParameters> {
  final MoviesRepository _baseMoviesRepository;

  GetTrendingMoviesUseCase(this._baseMoviesRepository);

  @override
  Future<Either<Failure, List<Media>>> call(TrendingMoviesParameters p) async {
    return await _baseMoviesRepository.getTrendingMovies(p.timeWindow.name);
  }
}
