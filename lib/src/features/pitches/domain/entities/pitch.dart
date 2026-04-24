class Pitch {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final double pricePerHour;
  final List<String> amenities;
  final String description;
  final String ownerId;
  final bool isAvailableToday;

  const Pitch({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.pricePerHour,
    required this.amenities,
    required this.description,
    required this.ownerId,
    this.isAvailableToday = true,
  });
}
