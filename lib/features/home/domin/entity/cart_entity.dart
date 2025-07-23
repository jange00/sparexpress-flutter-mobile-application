// import 'package:equatable/equatable.dart';

// class CartEntity extends Equatable {
//   final String? id; 
//   final String userId;
//   final String productId;

//   const CartEntity({
//     this.id,
//     required this.userId,
//     required this.productId,
//   });

//   @override
//   List<Object?> get props => [id, userId, productId];

//   factory CartEntity.empty() {
//     return const CartEntity(
//       id: null,
//       userId: '',
//       productId: '',
//     );
//   }
// }


import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String? id; 
  final String userId;
  final String productId;

  final String name;       
  final String imageUrl;   
  final double price;      
  final int quantity;      

  const CartEntity({
    this.id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  CartEntity copyWith({
    String? id,
    String? userId,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, userId, productId, name, imageUrl, price, quantity];
}
