import 'package:equatable/equatable.dart';

class Pitch extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String sportType;
  final PitchLocation location;
  final double pricePerHour;
  final List<String> amenities;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final bool isAvailable;
  final String openingTime;
  final String closingTime;
  final int slotDurationMinutes;

  const Pitch({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.sportType,
    required this.location,
    required this.pricePerHour,
    required this.amenities,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    required this.isAvailable,
    required this.openingTime,
    required this.closingTime,
    required this.slotDurationMinutes,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [id, name, location, rating, isAvailable];
}

class PitchLocation extends Equatable {
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const PitchLocation({
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get fullAddress => '$address, $city, $country';

  @override
  List<Object?> get props => [latitude, longitude];
}
