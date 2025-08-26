import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';

class NowPlayingMoviesParameters extends Equatable {
  final String region;

  const NowPlayingMoviesParameters({required this.region});

  @override
  List<Object> get props => [region];
}

class GetNowPlayingMoviesUseCase
    extends BaseUseCase<List<Media>, NowPlayingMoviesParameters> {
  final MoviesRepository _baseMoviesRepository;

  GetNowPlayingMoviesUseCase(this._baseMoviesRepository);

  @override
  Future<Either<Failure, List<Media>>> call(
      NowPlayingMoviesParameters p) async {
    return await _baseMoviesRepository.getNowPlayingMovies(region: p.region);
  }
}
