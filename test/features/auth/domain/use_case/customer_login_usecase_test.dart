import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_login_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late CustomerLoginUseCase useCase;
  late MockICustomerRepository mockRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockRepository = MockICustomerRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    when(() => mockTokenSharedPrefs.saveToken(any())).thenAnswer((_) async => const Right(true));
    useCase = CustomerLoginUseCase(
      customerRepository: mockRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'jwt_token_123';

  group('CustomerLoginUseCase', () {
    test('should return token when login is successful', () async {
      // arrange
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenAnswer((_) async => Right(testToken));

      // act
      final result = await useCase(LoginParams(email: testEmail, password: testPassword));

      // assert
      expect(result, Right(testToken));
      verify(() => mockRepository.loginCustomer(testEmail, testPassword)).called(1);
    });

    test('should return failure when login fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Invalid credentials');
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(LoginParams(email: testEmail, password: testPassword));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.loginCustomer(testEmail, testPassword)).called(1);
    });

    test('should handle empty email and password', () async {
      // arrange
      when(() => mockRepository.loginCustomer('', ''))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Email and password required')));

      // act
      final result = await useCase(LoginParams.initial());

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.loginCustomer('', '')).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(LoginParams(email: testEmail, password: testPassword));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.loginCustomer(testEmail, testPassword)).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await useCase(LoginParams(email: testEmail, password: testPassword));

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.loginCustomer(testEmail, testPassword)).called(1);
    });

    test('should handle different email formats', () async {
      // arrange
      const differentEmail = 'user@domain.com';
      when(() => mockRepository.loginCustomer(differentEmail, testPassword))
          .thenAnswer((_) async => Right(testToken));

      // act
      final result = await useCase(LoginParams(email: differentEmail, password: testPassword));

      // assert
      expect(result, Right(testToken));
      verify(() => mockRepository.loginCustomer(differentEmail, testPassword)).called(1);
    });
  });
} 