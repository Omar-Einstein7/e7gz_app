import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

import 'package:e7gz/src/features/auth/domain/entities/user.dart';
import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({required AuthService authService})
      : _authService = authService;

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _authService.authStateChanges.map(_mapUserDataToAppUser);
  }

  AppUser? _mapUserDataToAppUser(Map<String, dynamic>? userData) {
    if (userData == null) return null;
    
    // Normalize user data: handle cases where it's nested under 'user' or 'data'
    // or returned directly (common in auth/me vs auth/login)
    final userMap = userData['user'] as Map<String, dynamic>? ?? 
                   userData['data'] as Map<String, dynamic>? ?? 
                   userData;
                   
    return AppUser(
      id: userMap['id']?.toString() ?? userMap['_id']?.toString() ?? '',
      email: userMap['email'] ?? '',
      name: userMap['name'],
      photoUrl: userMap['photoUrl'],
      role: (userMap['role'] ?? userMap['userType'] ?? userMap['type'])?.toString().toLowerCase() ?? 'player',
      loyaltyPoints: (userMap['loyaltyPoints'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  FutureEither<AppUser> login({
    required String email, 
    required String password,
  }) async {
    final result = await _authService.login(email: email, password: password);
    
    return result.flatMap((userData) {
      final user = _mapUserDataToAppUser(userData);
      if (user == null) {
        return left(const ServerFailure('Login failed: User record not found'));
      }
      return right(user);
    });
  }

  @override
  FutureEither<AppUser> signUp({
    required String name, 
    required String email, 
    required String password,
    required String phone,
    String? role,
  }) async {
    final result = await _authService.signUp(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );

    return result.flatMap((userData) {
      final user = _mapUserDataToAppUser(userData);
      if (user == null) {
        return left(const ServerFailure('Sign up failed: User record corrupted'));
      }
      return right(user);
    });
  }

  @override
  FutureEither<void> forgotPassword({required String email}) {
    return _authService.forgotPassword(email: email);
  }

  @override
  FutureEither<void> logout() {
    return _authService.logout();
  }

  @override
  FutureEither<AppUser?> checkAuthState() async {
    final result = await _authService.getCurrentUser();
    
    return result.map(_mapUserDataToAppUser);
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
    return result.fold(
      (failure) => left(failure),
      (userData) {
        final user = _mapUserDataToAppUser(userData);
        if (user == null) return left(ServerFailure('Failed to update profile'));
        return right(user);
      },
    );
  }
}
