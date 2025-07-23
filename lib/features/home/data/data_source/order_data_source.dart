import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

abstract interface class IOrderDataSource {
  Future<List<OrderEntity>> getOrders();
  Future<void> createOrder(OrderEntity order);
  Future<void> deleteOrder(String id);
}
