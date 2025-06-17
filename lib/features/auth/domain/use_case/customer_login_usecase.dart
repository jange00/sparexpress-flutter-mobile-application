import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email,  required this.password});

  // Initial Constructor
  const LoginParams.initial() : email = '', password = '' ;
  @override
  List<Object?> get props => [email, password];
}

class CustomerLoginUseCase implements UseCaseWithParams<String, LoginParams> {
  final ICustomerRepository _customerRepository;

  CustomerLoginUseCase({required ICustomerRepository customerRepository})
    : _customerRepository = customerRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
  return await _customerRepository.loginCustomer(
    params.email, 
    params.password,
    );
  }
}