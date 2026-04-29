import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final int loyaltyPoints;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.loyaltyPoints = 0,
  });

  factory AppUser.empty() => const AppUser(id: '', email: '');

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [id, email, name, photoUrl, loyaltyPoints];
}
