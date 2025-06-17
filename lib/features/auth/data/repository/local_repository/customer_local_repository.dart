import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/data/data_source/local_datasource/customer_local_data_source.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';


class CustomerLocalRepository implements ICustomerRepository {
  final CustomerLocalDataSource _customerLocalDataSource;

  CustomerLocalRepository({
    required CustomerLocalDataSource customerLocalDataSource,
  }) : _customerLocalDataSource = customerLocalDataSource;

  @override
  Future<Either<Failure, CustomerEntity>> getCurrentUser() async {
    // TODO: implement loginCustomer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginCustomer(
    String email,
    String password,
  ) async {
    try {
      final result = await _customerLocalDataSource.loginCustomer(
        email,
        password,
      );
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerCustomer(CustomerEntity customer) async {
    try {
      await _customerLocalDataSource.registerCustomer(customer);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
