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
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      await _localDataSource.createOrder(order);
      return Right(order);
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
      final filtered = result.where((order) => order.userId == userId).toList();
      return Right(filtered);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
