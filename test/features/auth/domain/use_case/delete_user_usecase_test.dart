import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sparexpress/features/auth/domain/use_case/delete_user_usecase.dart';
import 'package:sparexpress/features/auth/domain/repository/user_repository.dart';

class MockIUserRepository extends Mock implements IUserRepository {}

void main() {
  late DeleteUserUsecase useCase;
  late MockIUserRepository mockRepository;

  setUp(() {
    mockRepository = MockIUserRepository();
    useCase = DeleteUserUsecase(repository: mockRepository);
  });

  group('DeleteUserUsecase', () {
    const testUserId = 'user123';

    test('should call repository deleteUser method', () async {
      when(() => mockRepository.deleteUser(testUserId))
          .thenAnswer((_) async {});

      await useCase(testUserId);
      verify(() => mockRepository.deleteUser(testUserId)).called(1);
    });

    test('should handle empty user ID', () async {
      when(() => mockRepository.deleteUser(''))
          .thenAnswer((_) async {});

      await useCase('');
      verify(() => mockRepository.deleteUser('')).called(1);
    });

    test('should handle long user ID', () async {
      const longUserId = 'very_long_user_id_that_might_exceed_normal_limits';
      when(() => mockRepository.deleteUser(longUserId))
          .thenAnswer((_) async {});

      await useCase(longUserId);
      verify(() => mockRepository.deleteUser(longUserId)).called(1);
    });

    test('should handle special characters in user ID', () async {
      const specialUserId = 'user123456789';
      when(() => mockRepository.deleteUser(specialUserId))
          .thenAnswer((_) async {});

      await useCase(specialUserId);
      verify(() => mockRepository.deleteUser(specialUserId)).called(1);
    });

    test('should handle numeric user ID', () async {
      const numericUserId = '12345';
      when(() => mockRepository.deleteUser(numericUserId))
          .thenAnswer((_) async {});

      await useCase(numericUserId);
      verify(() => mockRepository.deleteUser(numericUserId)).called(1);
    });
  });
} 