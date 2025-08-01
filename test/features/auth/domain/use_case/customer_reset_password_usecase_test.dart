import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_reset_password_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}

void main() {
  late CustomerResetPasswordUseCase useCase;
  late MockICustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockICustomerRepository();
    useCase = CustomerResetPasswordUseCase(customerRepository: mockRepository);
  });

  const testToken = 'reset_token_123';
  const testNewPassword = 'newpassword123';

  group('CustomerResetPasswordUseCase', () {
    test('should return success when reset is successful', () async {
      // arrange
      when(() => mockRepository.resetPassword(testToken, testNewPassword))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(ResetPasswordParams(token: testToken, newPassword: testNewPassword));

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.resetPassword(testToken, testNewPassword)).called(1);
    });

    test('should return failure when reset fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Reset failed');
      when(() => mockRepository.resetPassword(testToken, testNewPassword))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(ResetPasswordParams(token: testToken, newPassword: testNewPassword));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.resetPassword(testToken, testNewPassword)).called(1);
    });

    test('should handle empty token', () async {
      // arrange
      when(() => mockRepository.resetPassword('', testNewPassword))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Token required')));

      // act
      final result = await useCase(ResetPasswordParams(token: '', newPassword: testNewPassword));

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.resetPassword('', testNewPassword)).called(1);
    });

    test('should handle empty password', () async {
      // arrange
      when(() => mockRepository.resetPassword(testToken, ''))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Password required')));

      // act
      final result = await useCase(ResetPasswordParams(token: testToken, newPassword: ''));

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.resetPassword(testToken, '')).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.resetPassword(testToken, testNewPassword))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(ResetPasswordParams(token: testToken, newPassword: testNewPassword));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.resetPassword(testToken, testNewPassword)).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.resetPassword(testToken, testNewPassword))
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await useCase(ResetPasswordParams(token: testToken, newPassword: testNewPassword));

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.resetPassword(testToken, testNewPassword)).called(1);
    });
  });
} 