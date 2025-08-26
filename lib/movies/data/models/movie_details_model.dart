import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/core/utils/functions.dart';
import 'package:movie_stack/movies/data/models/cast_model.dart';
import 'package:movie_stack/movies/data/models/movie_model.dart';
import 'package:movie_stack/movies/data/models/review_model.dart';

class MovieDetailsModel extends MediaDetails {
  const MovieDetailsModel({
    required super.id,
    required super.tmdbID,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.releaseDate,
    required super.genres,
    super.runtime,
    super.numberOfSeasons,
    required super.overview,
    required super.voteAverage,
    required super.voteCount,
    required super.trailerUrl,
    super.cast,
    super.reviews,
    required super.similar,
    required super.isAdded,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
        id: 0,
        tmdbID: json['id'],
        title: json['title'],
        posterUrl: getPosterUrl(json['poster_path']),
        backdropUrl: getBackdropUrl(json['backdrop_path']),
        releaseDate: getDate(json['release_date']),
        genres: getGenres(json['genres']),
        runtime: getLength(json['runtime']),
        overview: json['overview'] ?? '',
        voteAverage:
            double.parse((json['vote_average'] as double).toStringAsFixed(1)),
        voteCount: getVotesCount(json['vote_count']),
        trailerUrl: getTrailerUrl(json),
        cast: List<CastModel>.from((json['credits']['cast'] as List? ?? [])
            .map((e) => CastModel.fromJson(e))),
        reviews: List<ReviewModel>.from(
            (json['reviews']['results'] as List? ?? [])
                .map((e) => ReviewModel.fromJson(e))),
        similar: List<MovieModel>.from(
            (json['similar']['results'] as List? ?? [])
                .map((e) => MovieModel.fromJson(e))),
        isAdded: false);
  }
}
