import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/repository/shipping_repository.dart';

class GetAllShippingAddressUsecase implements UseCaseWithoutParams<List<ShippingAddressEntity>> {
  final IShippingAddressRepository _repository;

  GetAllShippingAddressUsecase({required IShippingAddressRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<ShippingAddressEntity>>> call() async {
    try {
      final result = await _repository.getShippingAddressesByUserId();
      return result.fold(
        (failure) => Left(failure),
        (data) => Right(data),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
