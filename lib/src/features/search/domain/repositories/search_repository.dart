import '../../../../utils/typedefs.dart';
import '../../../pitches/domain/entities/pitch.dart';

abstract class SearchRepository {
  FutureEither<List<Pitch>> searchPitches({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
  });
}
