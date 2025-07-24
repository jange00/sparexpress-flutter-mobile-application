import 'package:sparexpress/features/auth/domain/repository/user_repository.dart';

class DeleteUserUsecase {
  final IUserRepository repository;

  DeleteUserUsecase({required this.repository});

  Future<void> call(String userId) async {
    await repository.deleteUser(userId);
  }
} 