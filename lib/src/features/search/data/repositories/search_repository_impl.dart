import 'package:fpdart/fpdart.dart';
import '../../../../utils/failure.dart';
import '../../../../utils/typedefs.dart';
import '../../../pitches/domain/entities/pitch.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<Pitch>> searchPitches({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
  }) async {
    try {
      final results = await remoteDataSource.searchPitches(
        query: query,
        sportType: sportType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        rating: rating,
      );
      return right(results);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
