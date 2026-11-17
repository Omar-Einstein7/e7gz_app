import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userPhoto,
    rating,
    comment,
    createdAt,
  ];
}