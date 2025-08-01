import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_image_upload_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICustomerRepository extends Mock implements ICustomerRepository {}

void main() {
  late CustomerImageUploadUseCase useCase;
  late MockICustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockICustomerRepository();
    useCase = CustomerImageUploadUseCase(customerRepository: mockRepository);
  });

  group('CustomerImageUploadUseCase', () {
    test('should return image URL when upload is successful', () async {
      // arrange
      final testFile = File('test_image.jpg');
      const imageUrl = 'https://example.com/profile.jpg';
      when(() => mockRepository.uploadProfilePicture(testFile))
          .thenAnswer((_) async => const Right(imageUrl));

      // act
      final result = await useCase(UploadImageParams(file: testFile));

      // assert
      expect(result, const Right(imageUrl));
      verify(() => mockRepository.uploadProfilePicture(testFile)).called(1);
    });

    test('should return failure when upload fails', () async {
      // arrange
      final testFile = File('test_image.jpg');
      final failure = RemoteDatabaseFailure(message: 'Upload failed');
      when(() => mockRepository.uploadProfilePicture(testFile))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(UploadImageParams(file: testFile));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.uploadProfilePicture(testFile)).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final testFile = File('test_image.jpg');
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.uploadProfilePicture(testFile))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(UploadImageParams(file: testFile));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.uploadProfilePicture(testFile)).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      final testFile = File('test_image.jpg');
      when(() => mockRepository.uploadProfilePicture(testFile))
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(() => useCase(UploadImageParams(file: testFile)), throwsException);
      verify(() => mockRepository.uploadProfilePicture(testFile)).called(1);
    });

    test('should handle file too large error', () async {
      // arrange
      final testFile = File('large_image.jpg');
      final failure = RemoteDatabaseFailure(message: 'File too large');
      when(() => mockRepository.uploadProfilePicture(testFile))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(UploadImageParams(file: testFile));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.uploadProfilePicture(testFile)).called(1);
    });
  });
} 