import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/data/data_source/remote_datasource/customer_remote_datasource.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class CustomerRemoteRepository implements ICustomerRepository{
  final CustomerRemoteDatasource _dataSource;

  CustomerRemoteRepository ({required CustomerRemoteDatasource datasource})
      : _dataSource = datasource;

      @override
  Future<Either<Failure, void>> registerCustomer(CustomerEntity customer) async {
    try {
      await _dataSource.registerCustomer(customer);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
   @override
  Future<Either<Failure, String>> loginCustomer(String email, String password) async {
    try {
      final token = await _dataSource.loginCustomer(email, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

   @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final result = await _dataSource.uploadProfilePicture(file.path);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

   @override
  Future<Either<Failure, CustomerEntity>> getCurrentUser() async {
    try {
      final customer = await _dataSource.getCurrentUser();
      return Right(customer);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await _dataSource.requestPasswordReset(email);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String newPassword) async {
    try {
      await _dataSource.resetPassword(token, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}