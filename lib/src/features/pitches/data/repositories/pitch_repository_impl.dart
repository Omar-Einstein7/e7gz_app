import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/domain/repositories/pitch_repository.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import '../datasources/pitch_remote_datasource.dart';
import '../models/pitch_model.dart';

class PitchRepositoryImpl implements PitchRepository {
  final PitchRemoteDataSource _remote;

  const PitchRepositoryImpl(this._remote);

  @override
  FutureEither<PitchListResult> getPitches({
    String? search,
    String? city,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 10,
  }) async {
    return runTask(() async {
      final json = await _remote.getPitches(
        search: search,
        city: city,
        sportType: sportType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: page,
        limit: limit,
      );

      final innerData = json['data'] as Map<String, dynamic>;
      final pitchesList = innerData['pitches'] as List<dynamic>;
      final pagination = innerData['pagination'] as Map<String, dynamic>? ?? {};

      final pitches = pitchesList
          .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
          .toList();

      return PitchListResult(
        pitches: pitches,
        total: (pagination['total'] as num?)?.toInt() ?? pitches.length,
        page: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      );
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<Pitch>> getNearbyPitches({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  }) async {
    return runTask(() async {
      final pitches = await _remote.getNearbyPitches(
        lat: lat,
        lng: lng,
        radiusMeters: radiusMeters,
      );
      return pitches;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<Pitch> getPitchById(String id) async {
    return runTask(() async {
      final pitch = await _remote.getPitchById(id);
      return pitch;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<void> createReview({
    required String pitchId,
    required double rating,
    required String comment,
  }) async {
    return runTask(() async {
      await _remote.createReview(
        pitchId: pitchId,
        rating: rating,
        comment: comment,
      );
    }, requiresNetwork: true);
  }
}
