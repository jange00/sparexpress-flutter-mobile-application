import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

abstract interface class IOrderRepository {
  // Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId(String userId);
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId();
  Future<Either<Failure, void>> createOrder(OrderEntity order);
  Future<Either<Failure, void>> deleteOrder(String orderId);
}
