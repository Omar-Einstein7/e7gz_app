import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

import 'package:e7gz/src/features/auth/domain/entities/user.dart';
import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({required AuthService authService})
    : _authService = authService;

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _authService.authStateChanges.map(
      (data) => data != null ? UserModel.fromJson(data) : null,
    );
  }

  @override
  FutureEither<AppUser> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email: email, password: password);

    return result.flatMap((userData) {
      if (userData == null) {
        return left(const ServerFailure('Login failed: User record not found'));
      }
      return right(UserModel.fromJson(userData));
    });
  }

  @override
  FutureEither<AppUser> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    final result = await _authService.signUp(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );

    return result.flatMap((userData) {
      if (userData == null) {
        return left(
          const ServerFailure('Sign up failed: User record corrupted'),
        );
      }
      return right(UserModel.fromJson(userData));
    });
  }

  @override
  FutureEither<void> forgotPassword({required String email}) {
    return _authService.forgotPassword(email: email);
  }

  @override
  FutureEither<String> verifyOtp({required String email, required String otp}) {
    return _authService.verifyOtp(email: email, otp: otp);
  }

  @override
  FutureEither<void> resetPassword({
    required String email,
    required String resetToken,
    required String password,
  }) {
    return _authService.resetPassword(
      email: email,
      resetToken: resetToken,
      password: password,
    );
  }

  @override
  FutureEither<void> logout() {
    return _authService.logout();
  }

  @override
  FutureEither<AppUser?> checkAuthState() async {
    final result = await _authService.getCurrentUser();
    return result.map((data) => data != null ? UserModel.fromJson(data) : null);
  }

  @override
  FutureEither<AppUser> updateProfile({
    String? name,
    String? phone,
    String? photoPath,
  }) async {
    final result = await _authService.updateProfile(
      name: name,
      phone: phone,
      photoPath: photoPath,
    );
    return result.fold((failure) => left(failure), (userData) {
      if (userData == null) {
        return left(const ServerFailure('Failed to update profile'));
      }
      return right(UserModel.fromJson(userData));
    });
  }
}
