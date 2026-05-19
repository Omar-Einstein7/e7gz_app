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
  final double morningPrice;
  final double nightPrice;

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
    required this.morningPrice,
    required this.nightPrice,
  });

  factory Pitch.empty() => const Pitch(
    id: '',
    name: 'Pitch Name Placeholder',
    description: '',
    ownerId: '',
    sportType: '',
    location: PitchLocation(
      address: 'Address',
      city: 'City',
      country: 'Country',
      latitude: 0,
      longitude: 0,
    ),
    pricePerHour: 0,
    amenities: [],
    images: [],
    rating: 0,
    reviewsCount: 0,
    isAvailable: true,
    openingTime: '',
    closingTime: '',
    slotDurationMinutes: 60,
    morningPrice: 0,
    nightPrice: 0,
  );

  String get imageUrl => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    ownerId,
    sportType,
    location,
    pricePerHour,
    amenities,
    images,
    rating,
    reviewsCount,
    isAvailable,
    openingTime,
    closingTime,
    slotDurationMinutes,
    morningPrice,
    nightPrice,
  ];
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
  List<Object?> get props => [address, city, country, latitude, longitude];
}
