import 'package:e7gz/src/imports/packages_imports.dart';

enum AuthStatus { initial, loading, success, failure }

enum ForgotStep { email, otp, newPassword }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? selectedRole;
  final bool obscurePassword;
  final ForgotStep forgotStep;
  final String? resetToken;

  const AuthState({
    required this.status,
    this.errorMessage,
    this.selectedRole,
    this.obscurePassword = true,
    this.forgotStep = ForgotStep.email,
    this.resetToken,
  });

  const AuthState.initial()
    : status = AuthStatus.initial,
      errorMessage = null,
      selectedRole = null,
      obscurePassword = true,
      forgotStep = ForgotStep.email,
      resetToken = null;

  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isFailure => status == AuthStatus.failure;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? selectedRole,
    bool? obscurePassword,
    ForgotStep? forgotStep,
    String? resetToken,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedRole: selectedRole ?? this.selectedRole,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      forgotStep: forgotStep ?? this.forgotStep,
      resetToken: resetToken ?? this.resetToken,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    selectedRole,
    obscurePassword,
    forgotStep,
    resetToken,
  ];
}