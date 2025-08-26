import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/search/data/datasource/search_remote_data_source.dart';
import 'package:movie_stack/search/domain/entities/search_result_item.dart';
import 'package:movie_stack/search/domain/repository/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchRemoteDataSource _baseSearchRemoteDataSource;

  SearchRepositoryImpl(this._baseSearchRemoteDataSource);

  @override
  Future<Either<Failure, List<SearchResultItem>>> search(String title) async {
    try {
      final resultModels = await _baseSearchRemoteDataSource.search(title);
      final searchItems =
          resultModels.map((model) => model.toEntity()).toList();
      return Right(searchItems);
    } on DioException catch (e) {
      final failure = ServerFailure.fromDioException(e);
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.',
          'Something went wrong. Please try again later.'));
    }
  }
}
