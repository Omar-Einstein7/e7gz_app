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
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        results: [],
        page: 1,
        hasReachedMax: false,
      ),
    );

    final result = await repository.searchPitches(
      query: query,
      sportType: sportType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      page: 1,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (results) => emit(
        state.copyWith(
          status: SearchStatus.success,
          results: results,
          hasReachedMax: results.length < 10,
        ),
      ),
    );
  }

  Future<void> loadMore({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
  }) async {
    if (state.hasReachedMax || state.status == SearchStatus.loading) return;

    final nextPage = state.page + 1;

    final result = await repository.searchPitches(
      query: query,
      sportType: sportType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      page: nextPage,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newResults) {
        if (newResults.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(
            state.copyWith(
              status: SearchStatus.success,
              results: List.of(state.results)..addAll(newResults),
              page: nextPage,
              hasReachedMax: newResults.length < 10,
            ),
          );
        }
      },
    );
  }
}
