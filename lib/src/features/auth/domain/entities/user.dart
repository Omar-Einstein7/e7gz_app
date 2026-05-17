import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String role;
  final int loyaltyPoints;
  final String? phone;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.role = 'player',
    this.loyaltyPoints = 0,
    this.phone,
  });

  factory AppUser.empty() => const AppUser(id: '', email: '');

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  bool get isOwner => role.toLowerCase() == 'owner';
  bool get isAdmin => role.toLowerCase() == 'admin';

  @override
  List<Object?> get props => [id, email, name, photoUrl, role, loyaltyPoints, phone];
}
