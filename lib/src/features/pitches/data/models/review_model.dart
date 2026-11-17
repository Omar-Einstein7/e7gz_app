import 'package:e7gz/src/features/pitches/domain/entities/reviews.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userPhoto,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] as Map<String, dynamic>?;
    return ReviewModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: user != null
          ? (user['_id']?.toString() ?? user['id']?.toString() ?? '')
          : (json['userId']?.toString() ?? ''),
      userName: user?['name']?.toString() ?? 'User',
      userPhoto: user?['photoUrl']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
