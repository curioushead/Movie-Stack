import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';

class GetMoviesDetailsUseCase extends BaseUseCase<MediaDetails, int> {
  final MoviesRepository _baseMoviesRepository;

  GetMoviesDetailsUseCase(this._baseMoviesRepository);

  @override
  Future<Either<Failure, MediaDetails>> call(int p) async {
    return await _baseMoviesRepository.getMovieDetails(p);
  }
}
