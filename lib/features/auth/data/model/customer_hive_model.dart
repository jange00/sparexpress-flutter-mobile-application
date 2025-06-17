import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:uuid/uuid.dart';

// dart run build_runner build -d 
part 'customer_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.customerTableId)
class CustomerHiveModel extends Equatable {
  @HiveField(0)
  final String? customerId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? profileImage;

  @HiveField(5)
  final String password;

  CustomerHiveModel({
    String? customerId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.password,
  }) : customerId = customerId ?? const Uuid().v4();

  // Initial Constructor
  const CustomerHiveModel.initial()
      : customerId = '',
        fullName = '',
        email = '',
        phoneNumber = '',
        profileImage = '',
        password = '';

  // From Entity
  factory CustomerHiveModel.fromEntity(CustomerEntity entity) {
    return CustomerHiveModel(
      customerId: entity.customerId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
      password: entity.password,
    );
  }

  // To Entity
  CustomerEntity toEntity() {
    return CustomerEntity(
      customerId: customerId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      password: password,
    );
  }

  @override
  List<Object?> get props => [
        customerId,
        fullName,
        email,
        phoneNumber,
        profileImage,
        password,
      ];
}
