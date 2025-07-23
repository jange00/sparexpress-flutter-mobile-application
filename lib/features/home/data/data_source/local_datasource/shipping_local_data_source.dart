import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/home/data/data_source/shipping_data_source.dart';
import 'package:sparexpress/features/home/data/model/shipping/shipping_address_hive_model.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';


class ShippingAddressLocalDataSource implements IShippingAddressDataSource {
  final HiveService _hiveService;

  ShippingAddressLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> addShippingAddress(ShippingAddressEntity address) async {
    try {
      final hiveModel = ShippingAddressHiveModel.fromEntity(address);
      await _hiveService.addShippingAddress(hiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteShippingAddress(String id) async {
    try {
      await _hiveService.deleteShippingAddress(id);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<ShippingAddressEntity>> getShippingAddresses() async {
    try {
      final hiveModels = await _hiveService.getAllShippingAddresses();
      return hiveModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  Future<List<ShippingAddressEntity>> getShippingAddressesByUserId(String userId) async {
    try {
      final hiveModels = await _hiveService.getAllShippingAddresses();
      return hiveModels
          .map((e) => e.toEntity())
          .where((address) => address.userId == userId)
          .toList();
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
