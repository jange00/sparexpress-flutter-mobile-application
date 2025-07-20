import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/repository/shipping_repository.dart';

class CreateShippingAddressUsecase implements UseCaseWithParams<void, ShippingAddressEntity> {
  final IShippingAddressRepository _repository;

  CreateShippingAddressUsecase({required IShippingAddressRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(ShippingAddressEntity address) async {
    try {
      final result = await _repository.createShippingAddress(address);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
