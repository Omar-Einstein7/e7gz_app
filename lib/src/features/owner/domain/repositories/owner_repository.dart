import 'package:fpdart/fpdart.dart';
import '../../../../utils/typedefs.dart';
import '../../../pitches/domain/entities/pitch.dart';

abstract class OwnerRepository {
  FutureEither<Map<String, dynamic>> getOwnerStats();
  FutureEither<List<Pitch>> getOwnerPitches();
}
