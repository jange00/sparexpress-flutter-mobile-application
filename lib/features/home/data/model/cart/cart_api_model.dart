// import 'package:equatable/equatable.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

// part 'cart_api_model.g.dart';

// @JsonSerializable()
// class CartApiModel extends Equatable {
//   @JsonKey(name: '_id')
//   final String? id;

//   final String userId;
//   final ProductInfo productId; // <-- Populated Product data from backend
//   final int quantity;

//   const CartApiModel({
//     this.id,
//     required this.userId,
//     required this.productId,
//     required this.quantity,
//   });

//   factory CartApiModel.fromJson(Map<String, dynamic> json) =>
//       _$CartApiModelFromJson(json);

//   Map<String, dynamic> toJson() => _$CartApiModelToJson(this);

//   /// Convert to domain entity
//   CartEntity toEntity() {
//     return CartEntity(
//       id: id,
//       userId: userId,
//       productId: productId.id ?? '',
//       name: productId.name,
//       imageUrl: productId.imageUrl,
//       price: productId.price,
//       quantity: quantity,
//     );
//   }

//   static List<CartEntity> toEntityList(List<dynamic> jsonList) {
//     return jsonList
//         .map((json) => CartApiModel.fromJson(json as Map<String, dynamic>).toEntity())
//         .toList();
//   }

//   @override
//   List<Object?> get props => [id, userId, productId, quantity];
// }

// @JsonSerializable()
// class ProductInfo extends Equatable {
//   @JsonKey(name: '_id')
//   final String? id;

//   final String name;
//   final String imageUrl;
//   final double price;

//   const ProductInfo({
//     this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.price,
//   });

//   factory ProductInfo.fromJson(Map<String, dynamic> json) =>
//       _$ProductInfoFromJson(json);

//   Map<String, dynamic> toJson() => _$ProductInfoToJson(this);

//   @override
//   List<Object?> get props => [id, name, imageUrl, price];
// }


import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';

part 'cart_api_model.g.dart';

@JsonSerializable()
class CartApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String userId;
  final ProductInfo productId; // populated product data from backend
  final int quantity;

  const CartApiModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  /// JSON serialization
  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String? ?? '',
      productId: ProductInfo.fromJson(json['productId'] as Map<String, dynamic>),
      quantity: json['quantity'] == null ? 1 : (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => _$CartApiModelToJson(this);

  /// Convert domain entity to API model (for sending data to API)
  factory CartApiModel.fromEntity(CartEntity entity) {
    return CartApiModel(
      id: entity.id,
      userId: entity.userId,
      productId: ProductInfo(
        id: entity.productId,
        name: entity.name ?? '',
        imageUrl: entity.imageUrl ?? '',
        price: entity.price ?? 0.0,
      ),
      quantity: entity.quantity,
    );
  }

  /// Convert API model to domain entity (for using in app)
  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: userId,
      productId: productId.id ?? '',
      name: productId.name,
      imageUrl: productId.imageUrl,
      price: productId.price,
      quantity: quantity,
    );
  }

  /// Convert JSON list to List<CartApiModel>
  static List<CartApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CartApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [id, userId, productId, quantity];
}

@JsonSerializable()
class ProductInfo extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String imageUrl;
  final double price;

  const ProductInfo({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    // Handle image field: could be a list or a string, or missing
    String imageUrl = '';
    if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl'] as String;
    } else if (json['image'] != null && json['image'] is List && (json['image'] as List).isNotEmpty) {
      imageUrl = (json['image'] as List).first.toString();
    }
    // Prepend base URL if imageUrl is a relative path
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = ApiEndpoints.imagrUrl + imageUrl.replaceFirst(RegExp(r'^uploads/'), '');
    }
    double price = 0.0;
    if (json['price'] != null) {
      price = (json['price'] as num).toDouble();
    }
    return ProductInfo(
      id: json['_id'] as String?,
      name: json['name'] as String? ?? '',
      imageUrl: imageUrl,
      price: price,
    );
  }

  Map<String, dynamic> toJson() => _$ProductInfoToJson(this);

  @override
  List<Object?> get props => [id, name, imageUrl, price];
}
