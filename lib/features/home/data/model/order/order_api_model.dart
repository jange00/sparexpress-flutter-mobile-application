import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderItemApiModel extends Equatable {
  final String productId;
  final String? productName;
  final String? productImage;
  final double? productPrice;
  final int quantity;
  final double total;

  const OrderItemApiModel({
    required this.productId,
    this.productName,
    this.productImage,
    this.productPrice,
    required this.quantity,
    required this.total,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    String productId = '';
    String? productName;
    String? productImage;
    double? productPrice;

    if (json['productId'] is Map) {
      final product = json['productId'] as Map<String, dynamic>;
      print('Product data in OrderItemApiModel: $product'); // Debug print

      productId = product['_id']?.toString() ?? '';
      productName = product['name']?.toString();
      
      // Debug print for image data
      print('Image data in product: ${product['image']}');
      
      if (product['image'] != null) {
        print('Image type: ${product['image'].runtimeType}');
        if (product['image'] is List && (product['image'] as List).isNotEmpty) {
          productImage = product['image'][0];
          print('Selected image from list: $productImage');
        } else if (product['image'] is String) {
          productImage = product['image'];
          print('Selected image string: $productImage');
        }
      }

      if (product['price'] != null) {
        productPrice = (product['price'] as num).toDouble();
      }
    } else {
      productId = json['productId']?.toString() ?? '';
    }

    print('Final productImage value: $productImage'); // Debug print

    return OrderItemApiModel(
      productId: productId,
      productName: productName,
      productImage: productImage,
      productPrice: productPrice,
      quantity: json['quantity'] is num ? (json['quantity'] as num).toInt() : 0,
      total: json['total'] is num ? (json['total'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() => _$OrderItemApiModelToJson(this);

  factory OrderItemApiModel.fromEntity(OrderItemEntity entity) {
    return OrderItemApiModel(
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      productPrice: entity.productPrice,
      quantity: entity.quantity,
      total: entity.total,
    );
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      productName: productName,
      productImage: productImage,
      productPrice: productPrice,
      quantity: quantity,
      total: total,
    );
  }

  @override
  List<Object?> get props => [productId, productName, productImage, productPrice, quantity, total];
}

@JsonSerializable()
class OrderApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? orderId;
  final String? userId;
  final double? amount;
  final String? shippingAddressId;
  final String? orderStatus;
  final List<OrderItemApiModel>? items;

  const OrderApiModel({
    this.orderId,
    this.userId,
    this.amount,
    this.shippingAddressId,
    this.orderStatus,
    this.items,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    // userId may be a string or a map
    String? userId;
    if (json['userId'] is String) {
      userId = json['userId'];
    } else if (json['userId'] is Map) {
      userId = json['userId']['_id']?.toString() ?? json['userId']['id']?.toString() ?? json['userId']['name']?.toString();
    }
    double? amount;
    if (json['Amount'] is double) {
      amount = json['Amount'];
    } else if (json['Amount'] is int) {
      amount = (json['Amount'] as int).toDouble();
    } else if (json['Amount'] is num) {
      amount = (json['Amount'] as num).toDouble();
    } else {
      amount = 0.0;
    }
    String? shippingAddressId;
    if (json['shippingAddressId'] is String) {
      shippingAddressId = json['shippingAddressId'];
    } else if (json['shippingAddressId'] is Map) {
      shippingAddressId = json['shippingAddressId']['_id']?.toString() ?? json['shippingAddressId']['id']?.toString();
    }
    String? orderStatus;
    if (json['orderStatus'] is String) {
      orderStatus = json['orderStatus'];
    } else if (json['orderStatus'] is Map) {
      orderStatus = json['orderStatus']['status']?.toString();
    }
    List<OrderItemApiModel>? items;
    if (json['items'] is List) {
      items = (json['items'] as List).map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return OrderApiModel(
      orderId: json['_id']?.toString(),
      userId: userId,
      amount: amount,
      shippingAddressId: shippingAddressId,
      orderStatus: orderStatus,
      items: items,
    );
  }

  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  factory OrderApiModel.fromEntity(OrderEntity entity) {
    return OrderApiModel(
      orderId: entity.orderId,
      userId: entity.userId,
      amount: entity.amount,
      shippingAddressId: entity.shippingAddressId,
      orderStatus: entity.orderStatus,
      items: entity.items.map((e) => OrderItemApiModel.fromEntity(e)).toList(),
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      orderId: orderId,
      userId: userId ?? '',
      amount: amount ?? 0.0,
      shippingAddressId: shippingAddressId ?? '',
      orderStatus: orderStatus ?? '',
      items: items?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  static List<OrderApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [orderId, userId, amount, shippingAddressId, orderStatus, items];
}
