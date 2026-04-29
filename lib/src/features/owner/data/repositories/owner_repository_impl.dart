import 'package:fpdart/fpdart.dart';
import '../../../../utils/failure.dart';
import '../../../../utils/typedefs.dart';
import '../../../pitches/domain/entities/pitch.dart';
import '../../domain/repositories/owner_repository.dart';
import '../datasources/owner_remote_datasource.dart';

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
}
