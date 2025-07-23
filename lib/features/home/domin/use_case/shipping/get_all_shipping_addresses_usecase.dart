import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/repository/shipping_repository.dart';

class GetAllShippingAddressUsecase implements UseCaseWithParams<List<ShippingAddressEntity>, String> {
  final IShippingAddressRepository _repository;

  GetAllShippingAddressUsecase({required IShippingAddressRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<ShippingAddressEntity>>> call(String userId) async {
    try {
      final result = await _repository.getShippingAddressesByUserId(userId);
      return result.fold(
        (failure) => Left(failure),
        (data) => Right(data),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
