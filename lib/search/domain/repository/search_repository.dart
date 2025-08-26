import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/search/domain/entities/search_result_item.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchResultItem>>> search(String title);
}
