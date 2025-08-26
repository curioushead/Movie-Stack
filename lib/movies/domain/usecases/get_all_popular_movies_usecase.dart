import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';

class GetAllPopularMoviesUseCase extends BaseUseCase<List<Media>, int> {
  final MoviesRepository _baseMoviesRepository;

  GetAllPopularMoviesUseCase(this._baseMoviesRepository);

  @override
  Future<Either<Failure, List<Media>>> call(int p) async {
    return await _baseMoviesRepository.getAllPopularMovies(p);
  }
}
