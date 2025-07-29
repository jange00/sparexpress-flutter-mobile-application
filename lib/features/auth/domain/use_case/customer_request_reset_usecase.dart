import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';

class RequestResetParams extends Equatable {
  final String email;

  const RequestResetParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class CustomerRequestResetUseCase implements UseCaseWithParams<void, RequestResetParams> {
  final ICustomerRepository _customerRepository;

  CustomerRequestResetUseCase({required ICustomerRepository customerRepository})
      : _customerRepository = customerRepository;

  @override
  Future<Either<Failure, void>> call(RequestResetParams params) async {
    return await _customerRepository.requestPasswordReset(params.email);
  }
} 