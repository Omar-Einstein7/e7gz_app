import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository}) : _repository = repository, super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.login(email: event.email, password: event.password);
    
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message));
        showGlobalToast(message: failure.message, status: 'error');
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.success));
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.signUp(
      name: event.name, 
      email: event.email, 
      password: event.password,
      role: event.role,
      phone: event.phone,
    );
    
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message));
        showGlobalToast(message: failure.message, status: 'error');
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.success));
      },
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.forgotPassword(email: event.email);
    
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message));
        showGlobalToast(message: failure.message, status: 'error');
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.success));
        showGlobalToast(message: 'Password reset link sent successfully', status: 'success');
      },
    );
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.updateProfile(
      name: event.name,
      phone: event.phone,
      photoPath: event.photoPath,
    );
    
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message));
        showGlobalToast(message: failure.message, status: 'error');
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.success));
        showGlobalToast(message: 'Profile updated successfully', status: 'success');
      },
    );
  }
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  final String phone;
  const SignUpRequested({
    required this.name, 
    required this.email, 
    required this.password,
    required this.role,
    required this.phone,
  });
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
}

class UpdateProfileRequested extends AuthEvent {
  final String? name;
  final String? phone;
  final String? photoPath;
  const UpdateProfileRequested({this.name, this.phone, this.photoPath});

  @override
  List<Object> get props => [name ?? '', phone ?? '', photoPath ?? ''];
}

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        errorMessage = null;

  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isFailure => status == AuthStatus.failure;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
