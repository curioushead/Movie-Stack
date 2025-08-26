// In lib/movies/domain/entities/review.dart
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart'; // Import Hive

part 'review.g.dart'; // Add this line

@HiveType(typeId: 4) // Make sure this typeId is unique
class Review extends Equatable {
  @HiveField(0)
  final String authorName;
  @HiveField(1)
  final String authorUserName;
  @HiveField(2)
  final String avatarUrl;
  @HiveField(3)
  final double rating;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final String elapsedTime;

  const Review({
    required this.authorName,
    required this.authorUserName,
    required this.avatarUrl,
    required this.rating,
    required this.content,
    required this.elapsedTime,
  });

  @override
  List<Object?> get props => [
    authorName,
    authorUserName,
    avatarUrl,
    rating,
    content,
    elapsedTime,
  ];
}
