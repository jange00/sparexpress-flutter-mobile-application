import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

abstract interface class ICustomerRepository{
  Future<Either<Failure, void>> registerCustomer(CustomerEntity customer);

  Future<Either<Failure, String>> loginCustomer (
    String email,
    String password,
  );
    Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, CustomerEntity>> getCurrentUser();

  // Forgot Password Methods
  Future<Either<Failure, void>> requestPasswordReset(String email);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
}