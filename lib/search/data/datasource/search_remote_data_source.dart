import 'package:dio/dio.dart';
import 'package:movie_stack/core/data/error/exceptions.dart';
import 'package:movie_stack/core/data/network/error_message_model.dart';
import 'package:movie_stack/search/data/datasource/search_api_service.dart';
import 'package:movie_stack/search/data/models/search_result_item_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultItemModel>> search(String title);
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final SearchApiService _apiService;

  SearchRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<SearchResultItemModel>> search(String title) async {
    try {
      final response = await _apiService.search(title, 1);
      return response.searchItems;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
