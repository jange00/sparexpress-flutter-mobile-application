import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';


abstract interface class IShippingAddressRepository {
  Future<Either<Failure, List<ShippingAddressEntity>>> getShippingAddressesByUserId(String userId);
  // Future<Either<Failure, List<ShippingAddressEntity>>> getShippingAddressesByUserId(String userId);
  Future<Either<Failure, void>> createShippingAddress(ShippingAddressEntity address);
  Future<Either<Failure, void>> deleteShippingAddress(String id);
}