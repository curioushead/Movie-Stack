import 'package:dio/dio.dart';
import 'package:movie_stack/search/data/models/search_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api_service.g.dart';

@RestApi()
abstract class SearchApiService {
  factory SearchApiService(Dio dio,
      {String baseUrl, ParseErrorLogger? errorLogger}) = _SearchApiService;

  @GET('/search/movie')
  Future<SearchResponseModel> search(
    @Query('query') String title,
    @Query('page') int page,
  );
}
