import 'package:e7gz/src/imports/core_imports.dart';
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
    int page = 1,
    int limit = 10,
  }) async {
    return runTask(() async {
      final results = await remoteDataSource.searchPitches(
        query: query,
        sportType: sportType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        rating: rating,
        page: page,
        limit: limit,
      );
      return results;
    }, requiresNetwork: true);
  }
}
