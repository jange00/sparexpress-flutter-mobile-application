import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_register_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}

void main() {
  late CustomerRegisterUseCase useCase;
  late MockICustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockICustomerRepository();
    useCase = CustomerRegisterUseCase(customerRepository: mockRepository);
  });

  const testParams = RegisterCustomerParams(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    password: 'password123',
    profileImage: 'profile.jpg',
  );

  const testEntity = CustomerEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    password: 'password123',
    profileImage: 'profile.jpg',
  );

  group('CustomerRegisterUseCase', () {
    test('should return success when registration is successful', () async {
      // arrange
      when(() => mockRepository.registerCustomer(testEntity))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.registerCustomer(testEntity)).called(1);
    });

    test('should return failure when registration fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Email already exists');
      when(() => mockRepository.registerCustomer(testEntity))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.registerCustomer(testEntity)).called(1);
    });

    test('should handle empty parameters', () async {
      // arrange
      const emptyParams = RegisterCustomerParams(
        fullName: '',
        email: '',
        phoneNumber: '',
        password: '',
        profileImage: null,
      );
      const emptyEntity = CustomerEntity(
        fullName: '',
        email: '',
        phoneNumber: '',
        password: '',
        profileImage: null,
      );
      when(() => mockRepository.registerCustomer(emptyEntity))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Invalid parameters')));

      // act
      final result = await useCase(emptyParams);

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.registerCustomer(emptyEntity)).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.registerCustomer(testEntity))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.registerCustomer(testEntity)).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.registerCustomer(testEntity))
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(() => useCase(testParams), throwsException);
      verify(() => mockRepository.registerCustomer(testEntity)).called(1);
    });
  });
} 