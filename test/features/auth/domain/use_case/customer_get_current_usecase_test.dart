import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_get_current_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}

void main() {
  late CustomerGetCurrentUseCase useCase;
  late MockICustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockICustomerRepository();
    useCase = CustomerGetCurrentUseCase(customerRepository: mockRepository);
  });

  const testCustomer = CustomerEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    password: 'password123',
    profileImage: 'profile.jpg',
  );

  group('CustomerGetCurrentUseCase', () {
    test('should return customer when getCurrentUser is successful', () async {
      // arrange
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(testCustomer));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testCustomer));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return failure when getCurrentUser fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'User not found');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should handle unauthorized access', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Unauthorized access');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.getCurrentUser())
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should handle customer without profile image', () async {
      // arrange
      const customerWithoutImage = CustomerEntity(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phoneNumber: '+1234567890',
        password: 'password123',
        profileImage: null,
      );
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(customerWithoutImage));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(customerWithoutImage));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should handle session expired', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Session expired');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should handle multiple calls', () async {
      // arrange
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(testCustomer));

      // act
      final result1 = await useCase();
      final result2 = await useCase();

      // assert
      expect(result1, Right(testCustomer));
      expect(result2, Right(testCustomer));
      verify(() => mockRepository.getCurrentUser()).called(2);
    });
  });
} 