import '../entities/pitch.dart';
import '../repositories/pitch_repository.dart';
import 'package:e7gz/src/utils/utils.dart';

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

class CreateReviewUseCase {
  final PitchRepository _repository;
  const CreateReviewUseCase(this._repository);

  FutureEither<void> call({
    required String pitchId,
    required double rating,
    required String comment,
  }) {
    return _repository.createReview(
      pitchId: pitchId,
      rating: rating,
      comment: comment,
    );
  }
}
