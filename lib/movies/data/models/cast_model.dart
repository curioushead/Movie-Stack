import 'package:movie_stack/core/utils/functions.dart';
import 'package:movie_stack/movies/domain/entities/cast.dart';

class CastModel extends Cast {
  const CastModel({
    required super.name,
    required super.profileUrl,
    required super.gender,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    final profilePath = json['profile_path'];
    final profileUrl = getProfileImageUrl(profilePath);

    return CastModel(
      name: json['name'],
      profileUrl: profileUrl,
      gender: json['gender'],
    );
  }
}
