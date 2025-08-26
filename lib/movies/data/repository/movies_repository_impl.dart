import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_stack/core/data/error/exceptions.dart';
import 'package:movie_stack/core/data/error/failure.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/movies/data/datasource/movies_local_data_source.dart';
import 'package:movie_stack/movies/data/datasource/movies_remote_data_source.dart';
import 'package:movie_stack/movies/domain/repository/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource _baseMoviesRemoteDataSource;
  final MoviesLocalDataSource _baseMoviesLocalDataSource;

  const MoviesRepositoryImpl(
      this._baseMoviesRemoteDataSource, this._baseMoviesLocalDataSource);

  // A generic wrapper to handle exceptions and return Either<Failure, T>
  Future<Either<Failure, T>> _tryCatchWrapper<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      final result = await apiCall();
      return Right(result);
    } on NetworkException catch (e) {
      debugPrint("[Repository] Network error: ${e.message}");
      return Left(NetworkFailure(e.message));
    } on LocalDatabaseException catch (e) {
      debugPrint("[Repository] Local database error: ${e.message}");
      return Left(DatabaseFailure(e.message));
    } on DioException catch (e) {
      debugPrint("[Repository] Dio error: ${e.message}");
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      debugPrint("[Repository] Unknown error: $e");
      return Left(ServerFailure(
          e.toString(), "Unexpected error occurred. Please try again later."));
    }
  }

  // A generic wrapper for cache-first logic
  Future<Either<Failure, List<Media>>> _cacheFirstWrapper(
    Future<List<Media>> Function() localCall,
    Future<List<Media>> Function() remoteCall,
    Future<void> Function(List<Media>) saveToLocal,
    String moviesType,
  ) async {
    try {
      final localMovies = await localCall();
      if (localMovies.isNotEmpty) {
        debugPrint(
            "[Repository] Found $moviesType locally. Loading from cache...");
        // Fetch and cache in the background for future use
        remoteCall().then((remoteMovies) {
          if (remoteMovies.isNotEmpty) {
            saveToLocal(remoteMovies).then((_) {
              debugPrint(
                  "🔄 [Repository] $moviesType cache updated successfully.");
            }).catchError((e) {
              debugPrint("[Repository] Failed to update $moviesType cache: $e");
            });
          }
        }).catchError((e) {
          debugPrint("[Repository] Failed to update $moviesType cache: $e");
        });
        return Right(localMovies);
      }
      debugPrint(
          " [Repository] No $moviesType found locally. Fetching from API...");
      final remoteMovies = await remoteCall();
      if (remoteMovies.isNotEmpty) {
        debugPrint(
            "[Repository] API fetch successful. Saving $moviesType to local database...");
        await saveToLocal(remoteMovies);
      }
      return Right(remoteMovies);
    } on NetworkException catch (e) {
      debugPrint(" [Repository] Network error: ${e.message}");
      return Left(NetworkFailure(
        e.message,
      ));
    } on LocalDatabaseException catch (e) {
      debugPrint("[Repository] Local database error: ${e.message}");
      return Left(DatabaseFailure(e.message));
    } on DioException catch (e) {
      debugPrint("[Repository] Dio error: ${e.message}");
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      debugPrint("[Repository] Unknown error: $e");
      return Left(ServerFailure(
          e.toString(), "Unexpected error occurred. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getNowPlayingMovies(
      {required String region}) async {
    return _cacheFirstWrapper(
      () => _baseMoviesLocalDataSource.getNowPlayingMovies(),
      () => _baseMoviesRemoteDataSource.getNowPlayingMovies(region: region),
      (movies) => _baseMoviesLocalDataSource.saveNowPlayingMovies(movies),
      'now playing movies',
    );
  }

  @override
  Future<Either<Failure, List<Media>>> getTrendingMovies(
      String timeWindow) async {
    return _cacheFirstWrapper(
      () => _baseMoviesLocalDataSource.getTrendingMovies(timeWindow),
      () => _baseMoviesRemoteDataSource.getTrendingMovies(timeWindow),
      (movies) =>
          _baseMoviesLocalDataSource.saveTrendingMovies(movies, timeWindow),
      'trending movies of $timeWindow',
    );
  }

  @override
  Future<Either<Failure, List<Media>>> getPopularMovies() async {
    return _cacheFirstWrapper(
      () => _baseMoviesLocalDataSource.getPopularMovies(),
      () => _baseMoviesRemoteDataSource.getPopularMovies(),
      (movies) => _baseMoviesLocalDataSource.savePopularMovies(movies),
      'popular movies',
    );
  }

  @override
  Future<Either<Failure, List<Media>>> getTopRatedMovies() async {
    return _cacheFirstWrapper(
      () => _baseMoviesLocalDataSource.getTopRatedMovies(),
      () => _baseMoviesRemoteDataSource.getTopRatedMovies(),
      (movies) => _baseMoviesLocalDataSource.saveTopRatedMovies(movies),
      'top rated movies',
    );
  }

  @override
  Future<Either<Failure, MediaDetails>> getMovieDetails(int movieId) async {
    return _tryCatchWrapper(() async {
      final localDetails =
          await _baseMoviesLocalDataSource.getMovieDetails(movieId);
      if (localDetails != null) {
        debugPrint(
            "[Repository] Found movie details locally. Loading from cache...");
        return localDetails;
      }
      debugPrint(
          " [Repository] No movie details found locally. Fetching from API...");
      final result = await _baseMoviesRemoteDataSource.getMovieDetails(movieId);
      await _baseMoviesLocalDataSource.saveMovieDetails(result);
      return result;
    });
  }

  @override
  Future<Either<Failure, List<Media>>> getAllPopularMovies(int page) async {
    return _tryCatchWrapper(() async {
      final localMovies =
          await _baseMoviesLocalDataSource.getAllPopularMovies();
      if (localMovies.isNotEmpty) {
        debugPrint(
            "[Repository] Found all popular movies locally. Loading from cache...");
        return localMovies;
      }
      debugPrint(
          " [Repository] No all popular movies found locally. Fetching from API...");
      final result =
          await _baseMoviesRemoteDataSource.getAllPopularMovies(page);
      if (result.isNotEmpty) {
        await _baseMoviesLocalDataSource.saveAllPopularMovies(result);
        debugPrint(
            "[Repository] API fetch successful. Saving all popular movies to local database...");
      }
      return result;
    });
  }

  @override
  Future<Either<Failure, List<Media>>> getAllTopRatedMovies(int page) async {
    return _tryCatchWrapper(() async {
      final localMovies =
          await _baseMoviesLocalDataSource.getAllTopRatedMovies();
      if (localMovies.isNotEmpty) {
        debugPrint(
            "[Repository] Found all top rated movies locally. Loading from cache...");
        return localMovies;
      }
      debugPrint(
          " [Repository] No all top rated movies found locally. Fetching from API...");
      final result =
          await _baseMoviesRemoteDataSource.getAllTopRatedMovies(page);
      if (result.isNotEmpty) {
        await _baseMoviesLocalDataSource.saveAllTopRatedMovies(result);
        debugPrint(
            "[Repository] API fetch successful. Saving all top rated movies to local database...");
      }
      return result;
    });
  }
}
