import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

class CustomerResetPasswordUseCase implements UseCaseWithParams<void, ResetPasswordParams> {
  final ICustomerRepository _customerRepository;

  CustomerResetPasswordUseCase({required ICustomerRepository customerRepository})
      : _customerRepository = customerRepository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await _customerRepository.resetPassword(params.token, params.newPassword);
  }
} 