import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e7gz/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository;

  AdminCubit({required AdminRepository repository})
    : _repository = repository,
      super(const AdminState());

  Future<void> loadDashboardStats() async {
    emit(state.copyWith(statsStatus: AdminStatus.loading));
    final result = await _repository.getDashboardStats();
    result.fold(
      (failure) => emit(
        state.copyWith(
          statsStatus: AdminStatus.failure,
          statsError: failure.message,
        ),
      ),
      (stats) =>
          emit(state.copyWith(statsStatus: AdminStatus.success, stats: stats)),
    );
  }

  Future<void> loadAllPitches() async {
    emit(state.copyWith(pitchesStatus: AdminStatus.loading));
    final result = await _repository.getAllPitches();
    result.fold(
      (failure) => emit(
        state.copyWith(
          pitchesStatus: AdminStatus.failure,
          pitchesError: failure.message,
        ),
      ),
      (pitches) => emit(
        state.copyWith(pitchesStatus: AdminStatus.success, pitches: pitches),
      ),
    );
  }

  Future<void> loadMyPitches() async {
    emit(state.copyWith(pitchesStatus: AdminStatus.loading));
    final result = await _repository.getMyPitches();
    result.fold(
      (failure) => emit(
        state.copyWith(
          pitchesStatus: AdminStatus.failure,
          pitchesError: failure.message,
        ),
      ),
      (pitches) => emit(
        state.copyWith(pitchesStatus: AdminStatus.success, pitches: pitches),
      ),
    );
  }

  Future<void> loadMyBookings() async {
    emit(state.copyWith(bookingsStatus: AdminStatus.loading));
    final result = await _repository.getMyBookings();
    result.fold(
      (failure) => emit(
        state.copyWith(
          bookingsStatus: AdminStatus.failure,
          bookingsError: failure.message,
        ),
      ),
      (bookings) => emit(
        state.copyWith(bookingsStatus: AdminStatus.success, bookings: bookings),
      ),
    );
  }

  Future<void> loadAllMatches() async {
    emit(state.copyWith(matchesStatus: AdminStatus.loading));
    final result = await _repository.getAllMatches();
    result.fold(
      (failure) => emit(
        state.copyWith(
          matchesStatus: AdminStatus.failure,
          matchesError: failure.message,
        ),
      ),
      (matches) => emit(
        state.copyWith(matchesStatus: AdminStatus.success, matches: matches),
      ),
    );
  }

  Future<void> loadNotifications() async {
    emit(state.copyWith(notificationsStatus: AdminStatus.loading));
    final result = await _repository.getNotifications();
    result.fold(
      (failure) => emit(
        state.copyWith(
          notificationsStatus: AdminStatus.failure,
          notificationsError: failure.message,
        ),
      ),
      (notifications) => emit(
        state.copyWith(
          notificationsStatus: AdminStatus.success,
          notifications: notifications,
        ),
      ),
    );
  }

  Future<void> markNotificationsAsRead() async {
    final result = await _repository.markNotificationsAsRead();
    result.fold((_) {}, (_) {
      loadNotifications(); // Reload to reflect status changes
    });
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(profileStatus: AdminStatus.loading));
    final result = await _repository.getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          profileStatus: AdminStatus.failure,
          profileError: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(profileStatus: AdminStatus.success, profile: profile),
      ),
    );
  }

  Future<void> createPitch(
    Map<String, dynamic> pitchData, {
    List<List<int>>? multipleImageBytes,
    List<String>? multipleFileNames,
  }) async {
    emit(
      state.copyWith(
        isMutating: true,
        mutationSuccess: false,
        mutationError: null,
      ),
    );
    final result = await _repository.createPitch(
      pitchData,
      multipleImageBytes: multipleImageBytes,
      multipleFileNames: multipleFileNames,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isMutating: false,
          mutationSuccess: false,
          mutationError: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(isMutating: false, mutationSuccess: true));
      },
    );
  }

  Future<void> deletePitch(String id) async {
    emit(
      state.copyWith(
        isMutating: true,
        mutationSuccess: false,
        mutationError: null,
      ),
    );
    final result = await _repository.deletePitch(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isMutating: false,
          mutationSuccess: false,
          mutationError: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(isMutating: false, mutationSuccess: true));
      },
    );
  }

  Future<void> updatePitch(
    String id,
    Map<String, dynamic> pitchData, {
    List<List<int>>? multipleImageBytes,
    List<String>? multipleFileNames,
  }) async {
    emit(
      state.copyWith(
        isMutating: true,
        mutationSuccess: false,
        mutationError: null,
      ),
    );
    final result = await _repository.updatePitch(
      id,
      pitchData,
      multipleImageBytes: multipleImageBytes,
      multipleFileNames: multipleFileNames,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isMutating: false,
          mutationSuccess: false,
          mutationError: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(isMutating: false, mutationSuccess: true));
      },
    );
  }
}
