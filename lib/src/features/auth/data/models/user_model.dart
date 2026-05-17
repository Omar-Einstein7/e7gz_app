import '../../domain/entities/user.dart';

/// Data model for [AppUser] with JSON serialization.
///
/// This class belongs to the DATA layer and handles API-specific logic.
class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.role,
    super.loyaltyPoints,
    super.phone,
  });

  /// Maps API response to [UserModel].
  ///
  /// Handles nested 'user' or 'data' keys and normalizes field names.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Normalize: Handle cases where data is nested or direct
    final Map<String, dynamic> data = json['user'] as Map<String, dynamic>? ??
        json['data'] as Map<String, dynamic>? ??
        json;

    return UserModel(
      id: data['id']?.toString() ?? data['_id']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      name: data['name']?.toString(),
      photoUrl: data['photoUrl']?.toString() ?? data['avatar']?.toString(),
      role: data['role']?.toString().toLowerCase() ?? 'player',
      loyaltyPoints: (data['loyaltyPoints'] as num?)?.toInt() ?? 0,
      phone: data['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'role': role,
      'loyaltyPoints': loyaltyPoints,
      'phone': phone,
    };
  }
}
