import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/owner/domain/repositories/owner_repository.dart';
import 'package:e7gz/src/features/owner/data/datasources/owner_remote_datasource.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<Map<String, dynamic>> getOwnerStats() async {
    try {
      final stats = await remoteDataSource.getStats();
      return right(stats);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<Pitch>> getOwnerPitches() async {
    try {
      final pitches = await remoteDataSource.getPitches();
      return right(pitches);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deletePitch(String pitchId) async {
    try {
      await remoteDataSource.deletePitch(pitchId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
