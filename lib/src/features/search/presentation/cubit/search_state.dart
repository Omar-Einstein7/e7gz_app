import 'package:equatable/equatable.dart';
import '../../../pitches/domain/entities/pitch.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Pitch> results;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Pitch>? results,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, errorMessage];
}
