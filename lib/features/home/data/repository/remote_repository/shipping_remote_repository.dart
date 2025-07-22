import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/shipping_remote_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/repository/shipping_repository.dart';

class ShippingRemoteRepository implements IShippingAddressRepository {
  final ShippingAddressRemoteDataSource _shippingRemoteDataSource;

  ShippingRemoteRepository({
    required ShippingAddressRemoteDataSource shippingRemoteDataSource,
  }) : _shippingRemoteDataSource = shippingRemoteDataSource;

  @override
  Future<Either<Failure, List<ShippingAddressEntity>>> getShippingAddressesByUserId(String userId) async {
    try {
      final addresses = await _shippingRemoteDataSource.getShippingAddressesByUserId(userId);
      return Right(addresses);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createShippingAddress(ShippingAddressEntity shipping) async {
    try {
      await _shippingRemoteDataSource.createShippingAddress(shipping);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShippingAddress(String addressId) async {
    try {
      await _shippingRemoteDataSource.deleteShippingAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
} 