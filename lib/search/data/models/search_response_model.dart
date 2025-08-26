import 'package:json_annotation/json_annotation.dart';
import 'package:movie_stack/search/data/models/search_result_item_model.dart';

part 'search_response_model.g.dart';

@JsonSerializable()
class SearchResponseModel {
  final int page;
  @JsonKey(name: 'results')
  final List<SearchResultItemModel> searchItems;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  SearchResponseModel({
    required this.page,
    required this.searchItems,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}