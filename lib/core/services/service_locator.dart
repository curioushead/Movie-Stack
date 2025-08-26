import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:movie_stack/core/data/network/api_constants.dart';
import 'package:movie_stack/core/resources/app_constants.dart';
import 'package:movie_stack/movies/data/datasource/movies_api_service.dart';
import 'package:movie_stack/movies/data/datasource/movies_local_data_source.dart';
// Movies
import 'package:movie_stack/movies/data/datasource/movies_remote_data_source.dart';
import 'package:movie_stack/movies/data/repository/movies_repository_impl.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';
import 'package:movie_stack/movies/domain/usecases/get_all_popular_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_all_top_rated_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_movie_details_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:movie_stack/movies/domain/usecases/get_trending_movies_usecase.dart';
import 'package:movie_stack/movies/presentation/controllers/movie_details_bloc/movie_details_bloc.dart';
import 'package:movie_stack/movies/presentation/controllers/movies_bloc/movies_bloc.dart';
import 'package:movie_stack/movies/presentation/controllers/popular_movies_bloc/popular_movies_bloc.dart';
import 'package:movie_stack/movies/presentation/controllers/top_rated_movies_bloc/top_rated_movies_bloc.dart';
import 'package:movie_stack/search/data/datasource/search_api_service.dart';
// Search
import 'package:movie_stack/search/data/datasource/search_remote_data_source.dart';
import 'package:movie_stack/search/data/repository/search_repository_impl.dart';
import 'package:movie_stack/search/domain/repository/search_repository.dart';
import 'package:movie_stack/search/domain/usecases/search_usecase.dart';
import 'package:movie_stack/search/presentation/controllers/search_bloc/search_bloc.dart';
// Watchlist
import 'package:movie_stack/watchlist/data/datasource/watchlist_local_data_source.dart';
import 'package:movie_stack/watchlist/data/repository/watchlist_repository_impl.dart';
import 'package:movie_stack/watchlist/domain/repository/watchlist_repository.dart';
import 'package:movie_stack/watchlist/domain/usecases/add_watchlist_item_usecase.dart';
import 'package:movie_stack/watchlist/domain/usecases/check_if_item_added_usecase.dart';
import 'package:movie_stack/watchlist/domain/usecases/get_watchlist_items_usecase.dart';
import 'package:movie_stack/watchlist/domain/usecases/remove_watchlist_item_usecase.dart';
import 'package:movie_stack/watchlist/presentation/controllers/watchlist_bloc/watchlist_bloc.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    _initCore();
    _initMovies();
    _initSearch();
    _initWatchlist();
  }

  // Core services
  static void _initCore() {
    if (!sl.isRegistered<Dio>()) {
      sl.registerLazySingleton<Dio>(() {
        final dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: ApiConstants.headers,
            connectTimeout: Duration(seconds: AppConstants.connectTimeout),
            receiveTimeout:
                const Duration(seconds: AppConstants.receiveTimeout),
            responseType: ResponseType.json,
          ),
        );
        dio.interceptors.add(RetryInterceptor(dio: dio));
        return dio;
      });
    }

    sl.registerLazySingleton<Logger>(() => Logger());
  }

  // Movies feature
  static void _initMovies() {
    sl.registerLazySingleton<MoviesApiService>(
      () => MoviesApiService(sl<Dio>(), baseUrl: ApiConstants.baseUrl),
    );

    sl.registerLazySingleton<MoviesRemoteDataSource>(
      () => MoviesRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<MoviesLocalDataSource>(
      () => MoviesLocalDataSourceImpl(),
    );

    sl.registerLazySingleton<MoviesRepository>(
      () => MoviesRepositoryImpl(sl(), sl()),
    );

    sl.registerLazySingleton(() => GetMoviesDetailsUseCase(sl()));
    sl.registerLazySingleton(() => GetAllPopularMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetAllTopRatedMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetNowPlayingMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetTrendingMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetTopRatedMoviesUseCase(sl()));

    sl.registerFactory(() => MoviesBloc(sl(), sl(), sl(), sl()));
    sl.registerFactory(() => MovieDetailsBloc(sl()));
    sl.registerFactory(() => PopularMoviesBloc(sl()));
    sl.registerFactory(() => TopRatedMoviesBloc(sl()));
  }

  // Search feature
  static void _initSearch() {
    sl.registerLazySingleton<SearchApiService>(
      () => SearchApiService(sl<Dio>(), baseUrl: ApiConstants.baseUrl),
    );
    sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(sl()),
    );
    sl.registerLazySingleton(() => SearchUseCase(sl()));
    sl.registerFactory(() => SearchBloc(sl()));
  }

  // Watchlist feature
  static void _initWatchlist() {
    sl.registerLazySingleton<WatchlistLocalDataSource>(
      () => WatchlistLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<WatchlistRepository>(
      () => WatchListRepositoryImpl(sl()),
    );

    sl.registerLazySingleton(() => GetWatchlistItemsUseCase(sl()));
    sl.registerLazySingleton(() => AddWatchlistItemUseCase(sl()));
    sl.registerLazySingleton(() => RemoveWatchlistItemUseCase(sl()));
    sl.registerLazySingleton(() => CheckIfItemAddedUseCase(sl()));

    sl.registerFactory(() => WatchlistBloc(sl(), sl(), sl(), sl()));
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;
  final Duration maxDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 2),
    this.maxDelay = const Duration(seconds: 30),
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      int retries = err.requestOptions.extra['retries'] ?? 0;

      if (retries < maxRetries) {
        retries++;
        err.requestOptions.extra['retries'] = retries;

        final delay = retryInterval * (1 << (retries - 1));
        final cappedDelay = delay > maxDelay ? maxDelay : delay;

        sl<Logger>().w(
          'Retry attempt $retries for ${err.requestOptions.uri}, '
          'waiting ${cappedDelay.inSeconds}s before retrying...',
        );

        await Future.delayed(cappedDelay);

        try {
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } on DioException catch (e) {
          handler.next(e);
          return;
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry on connection issues or timeout
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry on server errors
    final statusCode = err.response?.statusCode ?? 0;
    return [502, 503, 504].contains(statusCode);
  }
}
