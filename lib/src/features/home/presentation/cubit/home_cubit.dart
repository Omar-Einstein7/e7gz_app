import 'package:e7gz/src/imports/imports.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await repository.getHomeData();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(state.copyWith(status: HomeStatus.success, data: data)),
    );
  }
}
