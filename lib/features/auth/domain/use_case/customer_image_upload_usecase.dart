import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class UploadImageParams {
  final File file;
  
  const UploadImageParams({required this.file});
}

class CustomerImageUploadUseCase implements UseCaseWithParams<String, UploadImageParams> {
  final ICustomerRepository _customerRepository;

  CustomerImageUploadUseCase({required ICustomerRepository customerRepository})
    : _customerRepository = customerRepository;

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
   return _customerRepository.uploadProfilePicture(params.file);
  }
    
}