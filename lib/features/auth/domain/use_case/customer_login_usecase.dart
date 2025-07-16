import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
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
  final TokenSharedPrefs _tokenSharedPrefs;

  CustomerLoginUseCase({
    required ICustomerRepository customerRepository, 
    required TokenSharedPrefs tokenSharedPrefs 
    }) : _tokenSharedPrefs = tokenSharedPrefs,
    _customerRepository = customerRepository;
      

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
  // return await _customerRepository.loginCustomer(
  //   params.email, 
  //   params.password,
  //   );
  // }
  final token = await _customerRepository.loginCustomer(
    params.email, 
    params.password,
    );

    return token.fold((failure) => Left(failure), (token) {
      _tokenSharedPrefs.saveToken(token).then((result){
        result.fold(
          (failure) => debugPrint('Failed to save token: ${failure.message}'),
          (_) => debugPrint('Token saved successfully'),
        );
      });
      // save token here
      return Right(token);
    } );
  }
}