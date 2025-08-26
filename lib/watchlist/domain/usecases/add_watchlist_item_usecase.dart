import 'package:movie_stack/core/data/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/watchlist/domain/repository/watchlist_repository.dart';

class AddWatchlistItemUseCase extends BaseUseCase<int, Media> {
  final WatchlistRepository _baseWatchListRepository;

  AddWatchlistItemUseCase(this._baseWatchListRepository);

  @override
  Future<Either<Failure, int>> call(Media p) async {
    return await _baseWatchListRepository.addWatchListItem(p);
  }
}
