import 'package:e7gz/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:e7gz/src/services/auth_service.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    repository = AuthRepositoryImpl(authService: mockAuthService);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUserData = {
    'id': '1',
    'name': 'Test User',
    'email': tEmail,
    'role': 'player',
  };

  group('login', () {
    test('should return AppUser when login is successful', () async {
      // arrange
      when(() => mockAuthService.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => Right(tUserData));

      // act
      final result = await repository.login(email: tEmail, password: tPassword);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return failure'),
        (r) {
          expect(r.email, tEmail);
          expect(r.name, 'Test User');
        },
      );
      verify(() => mockAuthService.login(email: tEmail, password: tPassword)).called(1);
    });

    test('should return ServerFailure when login fails in service', () async {
      // arrange
      const tFailure = ServerFailure('Invalid credentials');
      when(() => mockAuthService.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await repository.login(email: tEmail, password: tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Invalid credentials'),
        (r) => fail('Should not return user'),
      );
    });

    test('should return ServerFailure when service returns null data', () async {
      // arrange
      when(() => mockAuthService.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await repository.login(email: tEmail, password: tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, contains('User record not found')),
        (r) => fail('Should not return user'),
      );
    });
  });

  group('checkAuthState', () {
    test('should return AppUser when user is authenticated', () async {
      // arrange
      when(() => mockAuthService.getCurrentUser())
          .thenAnswer((_) async => Right(tUserData));

      // act
      final result = await repository.checkAuthState();

      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception())?.name, 'Test User');
    });

    test('should return null when user is not authenticated', () async {
      // arrange
      when(() => mockAuthService.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await repository.checkAuthState();

      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception()), null);
    });
  });
}
