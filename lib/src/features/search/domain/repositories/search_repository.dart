import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

abstract class SearchRepository {
  FutureEither<List<Pitch>> searchPitches({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
    int page = 1,
    int limit = 10,
  });
}
