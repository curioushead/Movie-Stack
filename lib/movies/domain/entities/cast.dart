import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cast.g.dart';

@HiveType(typeId: 3)
class Cast extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String profileUrl;
  @HiveField(2)
  final int gender;

  const Cast({
    required this.name,
    required this.profileUrl,
    required this.gender,
  });

  @override
  List<Object?> get props => [
        name,
        profileUrl,
        gender,
      ];
}
