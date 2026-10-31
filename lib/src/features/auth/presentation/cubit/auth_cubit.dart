import 'package:e7gz/src/features/auth/presentation/cubit/auth_state.dart';

import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:e7gz/src/shared/helpers/show_toast.dart';
import 'package:e7gz/src/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



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

  void selectRole(String role) {
    emit(state.copyWith(selectedRole: role));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final role = state.selectedRole;
    if (role == null) {
      AppLogger.warning('🚩 signUp called but selectedRole is null');
      return;
    }

    AppLogger.info('🚀 signing up as $role');
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
        emit(
          state.copyWith(
            status: AuthStatus.success,
            forgotStep: ForgotStep.otp,
          ),
        );
        showGlobalToast(
          message: 'Password reset link sent successfully',
          status: 'success',
        );
      },
    );
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.verifyOtp(email: email, otp: otp);

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
      (resetToken) {
        emit(
          state.copyWith(
            status: AuthStatus.success,
            forgotStep: ForgotStep.newPassword,
            resetToken: resetToken,
          ),
        );
      },
    );
  }

  Future<void> resetPassword({
    required String email,
    required String password,
  }) async {
    final resetToken = state.resetToken;
    if (resetToken == null) {
      showGlobalToast(message: 'Missing reset token.', status: 'error');
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.resetPassword(
      email: email,
      resetToken: resetToken,
      password: password,
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
      (success) {
        emit(
          state.copyWith(
            status: AuthStatus.success,
            forgotStep: ForgotStep.email,
            resetToken: null,
          ),
        );
        // Reset password successful, UI can handle navigation back to login now or we show toast
        showGlobalToast(
          message: 'Password reset! Please log in with your new password.',
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
