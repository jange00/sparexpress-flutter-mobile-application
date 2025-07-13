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
      const expectedUrl = 'https://example.com/images/test_image.jpg';
      when(() => mockRepository.uploadProfilePicture(testFile))
          .thenAnswer((_) async => Right(expectedUrl));

      // act
      final result = await useCase(UploadImageParams(file: testFile));

      // assert
      expect(result, Right(expectedUrl));
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

    test('should handle file not found errors', () async {
      // arrange
      final nonExistentFile = File('non_existent.jpg');
      final failure = RemoteDatabaseFailure(message: 'File not found');
      when(() => mockRepository.uploadProfilePicture(nonExistentFile))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(UploadImageParams(file: nonExistentFile));

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.uploadProfilePicture(nonExistentFile)).called(1);
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

      // act
      final result = await useCase(UploadImageParams(file: testFile));

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.uploadProfilePicture(testFile)).called(1);
    });

    test('should handle different file types', () async {
      // arrange
      final pngFile = File('test_image.png');
      const expectedUrl = 'https://example.com/images/test_image.png';
      when(() => mockRepository.uploadProfilePicture(pngFile))
          .thenAnswer((_) async => Right(expectedUrl));

      // act
      final result = await useCase(UploadImageParams(file: pngFile));

      // assert
      expect(result, Right(expectedUrl));
      verify(() => mockRepository.uploadProfilePicture(pngFile)).called(1);
    });

    test('should handle large file uploads', () async {
      // arrange
      final largeFile = File('large_image.jpg');
      const expectedUrl = 'https://example.com/images/large_image.jpg';
      when(() => mockRepository.uploadProfilePicture(largeFile))
          .thenAnswer((_) async => Right(expectedUrl));

      // act
      final result = await useCase(UploadImageParams(file: largeFile));

      // assert
      expect(result, Right(expectedUrl));
      verify(() => mockRepository.uploadProfilePicture(largeFile)).called(1);
    });
  });
} 