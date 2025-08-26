import 'package:json_annotation/json_annotation.dart';
import 'package:movie_stack/core/utils/functions.dart';
import 'package:movie_stack/search/domain/entities/search_result_item.dart';

part 'search_result_item_model.g.dart';

@JsonSerializable()
class SearchResultItemModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'media_type', defaultValue: '')
  final String mediaType;

  SearchResultItemModel({
    required this.id,
    required this.title,
    required this.name,
    required this.posterPath,
    required this.mediaType,
  });

  factory SearchResultItemModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultItemModelToJson(this);

  SearchResultItem toEntity() {
    return SearchResultItem(
      tmdbID: id,
      posterUrl: getPosterUrl(posterPath),
      title: title ?? name ?? '',
      isMovie: true,
    );
  }
}
