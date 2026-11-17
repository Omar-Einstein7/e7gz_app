import 'package:e7gz/src/core/utils/task_runner.dart';
import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/owner/domain/repositories/owner_repository.dart';
import 'package:e7gz/src/features/owner/data/datasources/owner_remote_datasource.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;
  OwnerRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<Map<String, dynamic>> getOwnerStats() async {
    return runTask(() => remoteDataSource.getStats());
  }

  @override
  FutureEither<List<Pitch>> getOwnerPitches() async {
    return runTask(() => remoteDataSource.getPitches());
  }

  @override
  FutureEither<void> deletePitch(String pitchId) async {
    return runTask(() => remoteDataSource.deletePitch(pitchId));
  }
}
