import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import '../entities/pitch.dart';
import '../repositories/pitch_repository.dart';

class GetPitchesUseCase {
  final PitchRepository _repository;
  const GetPitchesUseCase(this._repository);

  FutureEither<PitchListResult> call({
    String? search,
    String? city,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 10,
  }) {
    return _repository.getPitches(
      search: search,
      city: city,
      sportType: sportType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
      limit: limit,
    );
  }
}

class GetNearbyPitchesUseCase {
  final PitchRepository _repository;
  const GetNearbyPitchesUseCase(this._repository);

  FutureEither<List<Pitch>> call({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  }) {
    return _repository.getNearbyPitches(
      lat: lat,
      lng: lng,
      radiusMeters: radiusMeters,
    );
  }
}

class GetPitchDetailsUseCase {
  final PitchRepository _repository;
  const GetPitchDetailsUseCase(this._repository);

  FutureEither<Pitch> call(String id) => _repository.getPitchById(id);
}
