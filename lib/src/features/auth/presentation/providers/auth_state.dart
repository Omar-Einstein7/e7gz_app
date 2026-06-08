// import 'package:e7gz/src/imports/packages_imports.dart';

// enum AuthStatus { initial, loading, success, failure }

// class AuthState extends Equatable {
//   final AuthStatus status;
//   final String? errorMessage;

//   const AuthState({required this.status, this.errorMessage});

//   const AuthState.initial() : status = AuthStatus.initial, errorMessage = null;

//   bool get isLoading => status == AuthStatus.loading;
//   bool get isSuccess => status == AuthStatus.success;
//   bool get isFailure => status == AuthStatus.failure;

//   AuthState copyWith({AuthStatus? status, String? errorMessage}) {
//     return AuthState(
//       status: status ?? this.status,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [status, errorMessage];
// }
