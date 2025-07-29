import 'package:sparexpress/features/auth/domain/repository/user_repository.dart';
import 'package:sparexpress/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRemoteRepository({required this.remoteDatasource});

  @override
  Future<void> deleteUser(String userId) async {
    await remoteDatasource.deleteUser(userId);
  }
} 