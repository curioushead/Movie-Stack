import 'package:json_annotation/json_annotation.dart';
import 'package:movie_stack/movies/data/models/movie_model.dart';

part 'movie_response_model.g.dart';

@JsonSerializable(createToJson: false)
class MovieResponseModel {
  @JsonKey(name: 'results')
  final List<MovieModel> movies;

  MovieResponseModel({
    required this.movies,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseModelFromJson(json);
}