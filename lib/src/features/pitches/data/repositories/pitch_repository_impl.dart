import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/domain/repositories/pitch_repository.dart';
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
    try {
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

      return right(PitchListResult(
        pitches: pitches,
        total: (pagination['total'] as num?)?.toInt() ?? pitches.length,
        page: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      ));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<Pitch>> getNearbyPitches({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  }) async {
    try {
      final pitches =
          await _remote.getNearbyPitches(lat: lat, lng: lng, radiusMeters: radiusMeters);
      return right(pitches);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Pitch> getPitchById(String id) async {
    try {
      final pitch = await _remote.getPitchById(id);
      return right(pitch);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
