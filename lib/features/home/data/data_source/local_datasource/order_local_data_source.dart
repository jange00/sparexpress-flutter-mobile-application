import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/home/data/data_source/order_data_source.dart';
import 'package:sparexpress/features/home/data/model/order/order_hive_model.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

class OrderLocalDataSource implements IOrderDataSource {
  final HiveService _hiveService;

  OrderLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> createOrder(OrderEntity order) async {
    try {
      final hiveModel = OrderHiveModel.fromEntity(order);
      await _hiveService.addOrder(hiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    try {
      await _hiveService.deleteOrder(id);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    try {
      final hiveModels = await _hiveService.getAllOrders();
      return hiveModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
