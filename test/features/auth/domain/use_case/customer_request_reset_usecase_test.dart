import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_request_reset_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}

void main() {
  late CustomerRequestResetUseCase useCase;
  late MockICustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockICustomerRepository();
    useCase = CustomerRequestResetUseCase(customerRepository: mockRepository);
  });

  group('CustomerRequestResetUseCase', () {
    const testEmail = 'test@example.com';

    test('should return success when request is successful', () async {
      // arrange
      when(() => mockRepository.requestPasswordReset(testEmail))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(RequestResetParams(email: testEmail));

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
    });

    test('should return failure when request fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Request failed');
      when(() => mockRepository.requestPasswordReset(testEmail))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(RequestResetParams(email: testEmail));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
    });

    test('should handle empty email', () async {
      // arrange
      when(() => mockRepository.requestPasswordReset(''))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Email required')));

      // act
      final result = await useCase(RequestResetParams(email: ''));

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.requestPasswordReset('')).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.requestPasswordReset(testEmail))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(RequestResetParams(email: testEmail));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.requestPasswordReset(testEmail))
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(() => useCase(RequestResetParams(email: testEmail)), throwsException);
      verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
    });
  });
} 