import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';

class GetAllTopRatedMoviesUseCase extends BaseUseCase<List<Media>, int> {
  final MoviesRepository _baseMoviesRespository;

  GetAllTopRatedMoviesUseCase(this._baseMoviesRespository);

  @override
  Future<Either<Failure, List<Media>>> call(int p) async {
    return await _baseMoviesRespository.getAllTopRatedMovies(p);
  }
}
