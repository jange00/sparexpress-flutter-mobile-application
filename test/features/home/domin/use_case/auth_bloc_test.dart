import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_login_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late CustomerLoginUseCase useCase;
  late MockICustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockICustomerRepository();
    final mockTokenPrefs = MockTokenSharedPrefs();
    useCase = CustomerLoginUseCase(
      customerRepository: mockRepository,
      tokenSharedPrefs: mockTokenPrefs,
    );
  });

  group('AuthBloc', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testToken = 'jwt_token_123';

    test('should return token when login is successful', () async {
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenAnswer((_) async => Right(testToken));

      final result = await useCase(LoginParams(email: testEmail, password: testPassword));
      expect(result, Right(testToken));
    });

    test('should return failure when login fails', () async {
      final failure = RemoteDatabaseFailure(message: 'Invalid credentials');
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(LoginParams(email: testEmail, password: testPassword));
      expect(result, Left(failure));
    });

    test('should handle empty email and password', () async {
      when(() => mockRepository.loginCustomer('', ''))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Email and password required')));

      final result = await useCase(LoginParams.initial());
      expect(result.isLeft(), true);
    });

    test('should handle network errors', () async {
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(LoginParams(email: testEmail, password: testPassword));
      expect(result, Left(failure));
    });

    test('should handle unexpected exceptions', () async {
      when(() => mockRepository.loginCustomer(testEmail, testPassword))
          .thenThrow(Exception('Unexpected error'));

      expect(() => useCase(LoginParams(email: testEmail, password: testPassword)), throwsException);
    });
  });
} 