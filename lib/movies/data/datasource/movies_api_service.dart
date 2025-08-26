import 'package:dio/dio.dart';
import 'package:movie_stack/movies/data/models/movie_details_model.dart';
import 'package:movie_stack/movies/data/models/movie_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'movies_api_service.g.dart';

@RestApi()
abstract class MoviesApiService {
  factory MoviesApiService(Dio dio,
      {String baseUrl, ParseErrorLogger? errorLogger}) = _MoviesApiService;

  @GET('/movie/now_playing')
  Future<MovieResponseModel> getNowPlayingMovies({@Query('region') String region = 'IN'});

  @GET('/trending/movie/{time_window}')
  Future<MovieResponseModel> getTrendingMovies(
      @Path('time_window') String timeWindow);

  @GET('/movie/popular')
  Future<MovieResponseModel> getPopularMovies();

  @GET('/movie/top_rated')
  Future<MovieResponseModel> getTopRatedMovies();

  @GET('/movie/{movie_id}?append_to_response=videos,credits,reviews,similar')
  Future<MovieDetailsModel> getMovieDetails(@Path('movie_id') int movieId);

  @GET('/movie/popular')
  Future<MovieResponseModel> getAllPopularMovies(@Query('page') int page);

  @GET('/movie/top_rated')
  Future<MovieResponseModel> getAllTopRatedMovies(@Query('page') int page);
}
