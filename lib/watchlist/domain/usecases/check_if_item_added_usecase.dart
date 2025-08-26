import 'package:movie_stack/core/data/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/domain/usecase/base_use_case.dart';
import 'package:movie_stack/watchlist/domain/repository/watchlist_repository.dart';

class CheckIfItemAddedUseCase extends BaseUseCase<int, int> {
  final WatchlistRepository _watchlistRepository;

  CheckIfItemAddedUseCase(this._watchlistRepository);
  @override
  Future<Either<Failure, int>> call(int p) async {
    return await _watchlistRepository.checkIfItemAdded(p);
  }
}
