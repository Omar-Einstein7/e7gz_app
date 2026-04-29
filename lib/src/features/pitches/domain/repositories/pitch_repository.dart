import 'package:e7gz/src/utils/typedefs.dart';
import '../entities/pitch.dart';

abstract class PitchRepository {
  /// Get a paginated list of pitches with optional filters.
  FutureEither<PitchListResult> getPitches({
    String? search,
    String? city,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 10,
  });

  /// Get pitches near a given coordinate within a radius (metres).
  FutureEither<List<Pitch>> getNearbyPitches({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  });

  /// Get a single pitch by its ID.
  FutureEither<Pitch> getPitchById(String id);
}

class PitchListResult {
  final List<Pitch> pitches;
  final int total;
  final int page;
  final int totalPages;

  const PitchListResult({
    required this.pitches,
    required this.total,
    required this.page,
    required this.totalPages,
  });
}
