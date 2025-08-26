import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/utils/functions.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 1) // Crucial: This must be a unique ID
class MovieModel extends Media {
  const MovieModel({
    required super.tmdbID,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.voteAverage,
    required super.releaseDate,
    required super.overview,
  }) : super(isMovie: true);

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    tmdbID: json['id'],
    title: json['title'],
    posterUrl: getPosterUrl(json['poster_path']),
    backdropUrl: getBackdropUrl(json['backdrop_path']),
    voteAverage: double.parse((json['vote_average']).toStringAsFixed(1)),
    releaseDate: getDate(json['release_date']),
    overview: json['overview'] ?? '',
  );
}
