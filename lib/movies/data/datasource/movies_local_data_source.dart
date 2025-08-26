import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_stack/core/data/error/exceptions.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/movies/data/models/movie_model.dart';

abstract class MoviesLocalDataSource {
  Future<List<Media>> getNowPlayingMovies();

  Future<void> saveNowPlayingMovies(List<Media> movies);

  Future<void> clearNowPlayingMovies();

  Future<List<Media>> getPopularMovies();

  Future<void> savePopularMovies(List<Media> movies);

  Future<void> clearPopularMovies();

  Future<List<Media>> getTopRatedMovies();

  Future<void> saveTopRatedMovies(List<Media> movies);

  Future<void> clearTopRatedMovies();

  Future<List<Media>> getTrendingMovies(String timeWindow);

  Future<void> saveTrendingMovies(List<Media> movies, String timeWindow);

  Future<void> clearTrendingMovies();

  Future<List<Media>> getAllPopularMovies();

  Future<void> saveAllPopularMovies(List<Media> movies);

  Future<void> clearAllPopularMovies();

  Future<List<Media>> getAllTopRatedMovies();

  Future<void> saveAllTopRatedMovies(List<Media> movies);

  Future<void> clearAllTopRatedMovies();

  Future<MediaDetails?> getMovieDetails(int movieId);

  Future<void> saveMovieDetails(MediaDetails details);

  Future<void> clearMovieDetails(int movieId);
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  // Now Playing Movies
  @override
  Future<List<Media>> getNowPlayingMovies() async {
    try {
      final box = await Hive.openBox<Media>('nowPlayingMovies');
      return box.values.toList();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> saveNowPlayingMovies(List<Media> movies) async {
    try {
      final box = await Hive.openBox<Media>('nowPlayingMovies');
      await box.clear(); // Clear old data
      await box.addAll(movies); // Add new data
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearNowPlayingMovies() async {
    try {
      final box = await Hive.openBox<Media>('nowPlayingMovies');
      await box.clear();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  // Popular Movies
  @override
  Future<List<Media>> getPopularMovies() async {
    try {
      final box = await Hive.openBox<Media>('popularMovies');
      // Add this temporary code to see the contents of the box
      if (kDebugMode) {
        print('--- Popular Movies from Hive ---');
        for (var movie in box.values) {
          // Check if the media is a movie before trying to access movie-specific properties
          if (movie is MovieModel) {
            print('Title: ${movie.title}, Poster: ${movie.posterUrl}');
          } else {
            print('Found a non-Movie media item: ${movie.title}');
          }
        }
        print('--------------------------------');
      }
      return box.values.toList();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> savePopularMovies(List<Media> movies) async {
    try {
      final box = await Hive.openBox<Media>('popularMovies');
      await box.clear();
      await box.addAll(movies);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearPopularMovies() async {
    try {
      final box = await Hive.openBox<Media>('popularMovies');
      await box.clear();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  // Top Rated Movies
  @override
  Future<List<Media>> getTopRatedMovies() async {
    try {
      final box = await Hive.openBox<Media>('topRatedMovies');
      return box.values.toList();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> saveTopRatedMovies(List<Media> movies) async {
    try {
      final box = await Hive.openBox<Media>('topRatedMovies');
      await box.clear();
      await box.addAll(movies);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearTopRatedMovies() async {
    try {
      final box = await Hive.openBox<Media>('topRatedMovies');
      await box.clear();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  // Trending Movies
  @override
  Future<List<Media>> getTrendingMovies(String timeWindow) async {
    try {
      final box = await Hive.openBox<Media>('trendingMovies_$timeWindow');
      return box.values.toList();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> saveTrendingMovies(List<Media> movies, String timeWindow) async {
    try {
      final box = await Hive.openBox<Media>('trendingMovies_$timeWindow');
      await box.clear();
      for (var movie in movies) {
        await box.add(movie);
      }
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearTrendingMovies() async {
    try {
      final box = await Hive.openBox<Media>('trendingMovies');
      await box.clear();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  // All Popular Movies
  @override
  Future<List<Media>> getAllPopularMovies() async {
    try {
      final box = await Hive.openBox<Media>('allPopularMovies');
      return box.values.toList();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> saveAllPopularMovies(List<Media> movies) async {
    try {
      final box = await Hive.openBox<Media>('allPopularMovies');
      await box.clear();
      await box.addAll(movies);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearAllPopularMovies() async {
    try {
      final box = await Hive.openBox<Media>('allPopularMovies');
      await box.clear();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  // All Top Rated Movies
  @override
  Future<List<Media>> getAllTopRatedMovies() async {
    try {
      final box = await Hive.openBox<Media>('allTopRatedMovies');
      return box.values.toList();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> saveAllTopRatedMovies(List<Media> movies) async {
    try {
      final box = await Hive.openBox<Media>('allTopRatedMovies');
      await box.clear();
      await box.addAll(movies);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearAllTopRatedMovies() async {
    try {
      final box = await Hive.openBox<Media>('allTopRatedMovies');
      await box.clear();
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  // Movie Details
  @override
  Future<MediaDetails?> getMovieDetails(int movieId) async {
    try {
      final box = await Hive.openBox<MediaDetails>('movieDetails');
      return box.get(movieId);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> saveMovieDetails(MediaDetails details) async {
    try {
      final box = await Hive.openBox<MediaDetails>('movieDetails');
      await box.put(details.id, details);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> clearMovieDetails(int movieId) async {
    try {
      final box = await Hive.openBox<MediaDetails>('movieDetails');
      await box.delete(movieId);
    } catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }
}
