import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

abstract class OwnerRepository {
  FutureEither<Map<String, dynamic>> getOwnerStats();
  FutureEither<List<Pitch>> getOwnerPitches();
  FutureEither<void> deletePitch(String pitchId);
}
