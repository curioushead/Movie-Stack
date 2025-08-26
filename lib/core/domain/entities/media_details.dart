import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/movies/data/models/cast_model.dart';
import 'package:movie_stack/movies/data/models/review_model.dart';

part 'media_details.g.dart';

@HiveType(typeId: 2)
class MediaDetails extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int tmdbID;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String posterUrl;
  @HiveField(4)
  final String backdropUrl;
  @HiveField(5)
  final String releaseDate;
  @HiveField(6)
  final String genres;
  @HiveField(7)
  final String? runtime;
  @HiveField(8)
  final int? numberOfSeasons;
  @HiveField(9)
  final String overview;
  @HiveField(10)
  final double voteAverage;
  @HiveField(11)
  final String voteCount;
  @HiveField(12)
  final String trailerUrl;
  @HiveField(13)
  final List<CastModel>? cast; // Change this from Cast to CastModel
  @HiveField(14)
  final List<ReviewModel>? reviews; // Change this from Review to ReviewModel
  @HiveField(15)
  final List<Media> similar;
  @HiveField(16)
  final bool isAdded;

  const MediaDetails({
    required this.id,
    required this.tmdbID,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.releaseDate,
    required this.genres,
    this.runtime,
    this.numberOfSeasons,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.trailerUrl,
    this.cast,
    this.reviews,
    required this.similar,
    this.isAdded = false,
  });

  // New: Implement the copyWith method
  MediaDetails copyWith({
    int? id,
    int? tmdbID,
    String? title,
    String? posterUrl,
    String? backdropUrl,
    String? releaseDate,
    String? genres,
    String? runtime,
    int? numberOfSeasons,
    String? overview,
    double? voteAverage,
    String? voteCount,
    String? trailerUrl,
    List<CastModel>? cast,
    List<ReviewModel>? reviews,
    List<Media>? similar,
    bool? isAdded,
  }) {
    return MediaDetails(
      id: id ?? this.id,
      tmdbID: tmdbID ?? this.tmdbID,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      runtime: runtime ?? this.runtime,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      cast: cast ?? this.cast,
      reviews: reviews ?? this.reviews,
      similar: similar ?? this.similar,
      isAdded: isAdded ?? this.isAdded,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tmdbID,
        title,
        posterUrl,
        backdropUrl,
        releaseDate,
        genres,
        runtime,
        numberOfSeasons,
        overview,
        voteAverage,
        voteCount,
        trailerUrl,
        cast,
        reviews,
        similar,
        isAdded,
      ];
}
