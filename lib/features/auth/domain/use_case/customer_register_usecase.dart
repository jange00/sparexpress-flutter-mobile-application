import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class RegisterCustomerParams extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? profileImage;

  const RegisterCustomerParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profileImage,
  });

  const RegisterCustomerParams.initial({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.profileImage,
  });

  @override
  List<Object?> get props => [fullName, email, phoneNumber, password, profileImage];
}

class CustomerRegisterUseCase implements UseCaseWithParams<void, RegisterCustomerParams> {
  final ICustomerRepository _customerRepository;

  CustomerRegisterUseCase({required ICustomerRepository customerRepository})
      : _customerRepository = customerRepository;

  @override
  Future<Either<Failure, void>> call(RegisterCustomerParams params) {
    final customerEntity = CustomerEntity(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
      profileImage: params.profileImage,
    );
    return _customerRepository.registerCustomer(customerEntity);
  }
}
