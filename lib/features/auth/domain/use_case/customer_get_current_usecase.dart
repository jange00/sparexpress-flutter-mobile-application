import 'package:dartz/dartz.dart';

import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class CustomerGetCurrentUseCase implements UseCaseWithoutParams<CustomerEntity> {
  final ICustomerRepository _customerRepository;

  CustomerGetCurrentUseCase({required ICustomerRepository customerRepository})
    : _customerRepository = customerRepository;


  @override
  Future<Either<Failure, CustomerEntity>> call() {
    return _customerRepository.getCurrentUser();
  }}