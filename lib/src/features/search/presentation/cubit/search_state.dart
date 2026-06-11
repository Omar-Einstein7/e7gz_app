import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Pitch> results;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Pitch>? results,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    results,
    errorMessage,
    page,
    hasReachedMax,
  ];
}
