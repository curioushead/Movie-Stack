import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';

class GetPopularMoviesUseCase
    implements BaseUseCase<List<Media>, NoParameters> {
  final MoviesRepository _baseMoviesRepository;

  const GetPopularMoviesUseCase(this._baseMoviesRepository);

  @override
  Future<Either<Failure, List<Media>>> call(NoParameters parameters) async {
    return _baseMoviesRepository.getPopularMovies();
  }
}
