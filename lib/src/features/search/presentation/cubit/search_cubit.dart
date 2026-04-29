import 'package:e7gz/src/imports/imports.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;

  SearchCubit({required this.repository}) : super(const SearchState());

  Future<void> search({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
  }) async {
    emit(state.copyWith(status: SearchStatus.loading));
    
    final result = await repository.searchPitches(
      query: query,
      sportType: sportType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: failure.message,
      )),
      (results) => emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
      )),
    );
  }
}
