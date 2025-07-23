import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/order_remote_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/repository/order_repository.dart';

class OrderRemoteRepository implements IOrderRepository {
  final OrderRemoteDataSource _orderRemoteDataSource;

  OrderRemoteRepository({
    required OrderRemoteDataSource orderRemoteDataSource,
  }) : _orderRemoteDataSource = orderRemoteDataSource;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId(String userId) async {
    try {
      final orders = await _orderRemoteDataSource.getOrdersByUserId(userId);
      return Right(orders);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final createdOrder = await _orderRemoteDataSource.createOrder(order);
      return Right(createdOrder.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String id) async {
    try {
      await _orderRemoteDataSource.deleteOrder(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
