import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

class PitchModel extends Pitch {
  const PitchModel({
    required super.id,
    required super.name,
    required super.description,
    required super.ownerId,
    required super.sportType,
    required super.location,
    required super.pricePerHour,
    required super.amenities,
    required super.images,
    required super.rating,
    required super.reviewsCount,
    required super.isAvailable,
    required super.openingTime,
    required super.closingTime,
    required super.slotDurationMinutes,
  });

  factory PitchModel.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>? ?? {};
    final coords = loc['coordinates'] as Map<String, dynamic>? ?? {};
    final coordsList = coords['coordinates'] as List<dynamic>? ?? [0.0, 0.0];

    return PitchModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ownerId: _extractOwnerId(json['ownerId']),
      sportType: json['sportType'] ?? 'football',
      location: PitchLocation(
        address: loc['address'] ?? '',
        city: loc['city'] ?? '',
        country: loc['country'] ?? 'Egypt',
        // ORS / GeoJSON: [longitude, latitude]
        longitude: (coordsList[0] as num).toDouble(),
        latitude: (coordsList[1] as num).toDouble(),
      ),
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      openingTime: json['openingTime'] ?? '06:00',
      closingTime: json['closingTime'] ?? '24:00',
      slotDurationMinutes: (json['slotDurationMinutes'] as num?)?.toInt() ?? 60,
    );
  }

  static String _extractOwnerId(dynamic owner) {
    if (owner == null) return '';
    if (owner is String) return owner;
    if (owner is Map) return owner['_id']?.toString() ?? '';
    return '';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'sportType': sportType,
        'location': {
          'address': location.address,
          'city': location.city,
          'country': location.country,
          'coordinates': {
            'type': 'Point',
            'coordinates': [location.longitude, location.latitude],
          },
        },
        'pricePerHour': pricePerHour,
        'amenities': amenities,
        'images': images,
        'openingTime': openingTime,
        'closingTime': closingTime,
        'slotDurationMinutes': slotDurationMinutes,
      };
}
