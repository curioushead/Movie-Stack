import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_stack/core/data/error/exceptions.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/movies/data/datasource/movies_api_service.dart';
import 'package:movie_stack/movies/data/models/movie_details_model.dart';
import 'package:movie_stack/movies/data/models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<Media>> getNowPlayingMovies({required String region});

  Future<List<Media>> getTrendingMovies(String timeWindow);

  Future<MediaDetails> getMovieDetails(int movieId);

  Future<List<Media>> getAllPopularMovies(int page);

  Future<List<Media>> getAllTopRatedMovies(int page);

  Future<List<Media>> getPopularMovies();

  Future<List<Media>> getTopRatedMovies();
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final MoviesApiService _apiService;

  MoviesRemoteDataSourceImpl(this._apiService);

  // This is a new, generic helper method for all API calls
  Future<T> _tryCatchWrapper<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return result;
    } on DioException catch (e) {
      debugPrint("[RemoteDataSource] Dio error: ${e.message}");
      // Catch SocketException specifically and rethrow as a custom exception
      if (e.error is SocketException) {
        throw const NetworkException('Connection failed');
      }
      // For all other Dio errors, rethrow the DioException
      rethrow;
    } on Exception {
      // Re-throw any other unhandled exceptions
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies({required String region}) async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getNowPlayingMovies(region: region);
      return response.movies;
    });
  }

  @override
  Future<List<MovieModel>> getTrendingMovies(String timeWindow) async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getTrendingMovies(timeWindow);
      return response.movies;
    });
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getPopularMovies();
      return response.movies;
    });
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getTopRatedMovies();
      return response.movies;
    });
  }

  @override
  Future<List<MovieModel>> getAllPopularMovies(int page) async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getAllPopularMovies(page);
      return response.movies;
    });
  }

  @override
  Future<List<MovieModel>> getAllTopRatedMovies(int page) async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getAllTopRatedMovies(page);
      return response.movies;
    });
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    return _tryCatchWrapper(() async {
      final response = await _apiService.getMovieDetails(movieId);
      return response;
    });
  }
}
