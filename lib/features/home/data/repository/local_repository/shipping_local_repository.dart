import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/local_datasource/shipping_local_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/repository/shipping_repository.dart';

class ShippingLocalRepository implements IShippingAddressRepository {
  final ShippingAddressLocalDataSource _localDataSource;

  ShippingLocalRepository({required ShippingAddressLocalDataSource shippingLocalDataSource})
      : _localDataSource = shippingLocalDataSource;

  @override
  Future<Either<Failure, void>> createShippingAddress(ShippingAddressEntity shipping) async {
    try {
      await _localDataSource.addShippingAddress(shipping);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShippingAddress(String id) async {
    try {
      await _localDataSource.deleteShippingAddress(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShippingAddressEntity>>> getShippingAddressesByUserId(String userId) async {
    try {
      final addresses = await _localDataSource.getShippingAddressesByUserId(userId);
      return Right(addresses);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
