import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/repository/shipping_repository.dart';

class DeleteShippingAddressUsecase implements UseCaseWithParams<void, String> {
  final IShippingAddressRepository _repository;

  DeleteShippingAddressUsecase({required IShippingAddressRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      final result = await _repository.deleteShippingAddress(id);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
