import 'package:equatable/equatable.dart';
import '../../domain/entities/home_data.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeData? data;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeData? data,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
