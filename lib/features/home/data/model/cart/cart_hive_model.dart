import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:uuid/uuid.dart';

part 'cart_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.cartId)
class CartHiveModel extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String productId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final int quantity;

  CartHiveModel({
    String? id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  }) : id = id ?? const Uuid().v4();

  const CartHiveModel.initial()
      : id = '',
        userId = '',
        productId = '',
        name = '',
        imageUrl = '',
        price = 0.0,
        quantity = 0;

  factory CartHiveModel.fromEntity(CartEntity entity) => CartHiveModel(
        id: entity.id,
        userId: entity.userId,
        productId: entity.productId,
        name: entity.name,
        imageUrl: entity.imageUrl,
        price: entity.price,
        quantity: entity.quantity,
      );

  CartEntity toEntity() => CartEntity(
        id: id,
        userId: userId,
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
      );

  static List<CartEntity> toEntityList(List<CartHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props =>
      [id, userId, productId, name, imageUrl, price, quantity];
}
