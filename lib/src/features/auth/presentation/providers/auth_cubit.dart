import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({required this.status, this.errorMessage});

  const AuthState.initial() : status = AuthStatus.initial, errorMessage = null;

  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isFailure => status == AuthStatus.failure;

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      super(const AuthState.initial());

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.login(email: email, password: password);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: failure.message,
          ),
        );
        showGlobalToast(message: failure.message, status: 'error');
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.success));
      },
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.signUp(
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: failure.message,
          ),
        );
        showGlobalToast(message: failure.message, status: 'error');
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.success));
      },
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.forgotPassword(email: email);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: failure.message,
          ),
        );
        showGlobalToast(message: failure.message, status: 'error');
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.success));
        showGlobalToast(
          message: 'Password reset link sent successfully',
          status: 'success',
        );
      },
    );
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoPath,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.updateProfile(
      name: name,
      phone: phone,
      photoPath: photoPath,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: failure.message,
          ),
        );
        showGlobalToast(message: failure.message, status: 'error');
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.success));
        showGlobalToast(
          message: 'Profile updated successfully',
          status: 'success',
        );
      },
    );
  }
}
