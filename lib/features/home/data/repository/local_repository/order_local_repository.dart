import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/local_datasource/order_local_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/repository/order_repository.dart';

class OrderLocalRepository implements IOrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderLocalRepository({required OrderLocalDataSource orderLocalDataSource})
      : _localDataSource = orderLocalDataSource;

  @override
  Future<Either<Failure, void>> createOrder(OrderEntity order) async {
    try {
      await _localDataSource.createOrder(order);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String id) async {
    try {
      await _localDataSource.deleteOrder(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId(String userId) async {
    try {
      final result = await _localDataSource.getOrders();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
