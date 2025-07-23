import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/home/data/data_source/payment_data_source.dart';
import 'package:sparexpress/features/home/data/model/payment/payment_hive_model.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

class PaymentLocalDataSource implements IPaymentDataSource {
  final HiveService _hiveService;

  PaymentLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> createPayment(PaymentEntity payment) async {
    try {
      final hiveModel = PaymentHiveModel.fromEntity(payment);
      await _hiveService.addPayment(hiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<void> deletePayment(String id) async {
    try {
      await _hiveService.deletePayment(id);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<PaymentEntity>> getPayments() async {
    try {
      final hiveModels = await _hiveService.getAllPayments();
      return hiveModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
