class Review {
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

  factory Review.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] as Map<String, dynamic>?;
    return Review(
      id: json['_id'] ?? '',
      userId: user != null ? (user['_id'] ?? '') : (json['userId'] ?? ''),
      userName: user?['name'] ?? 'User',
      userPhoto: user?['photoUrl'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
