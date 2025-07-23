import 'package:equatable/equatable.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

abstract class OfferState extends Equatable {
  const OfferState();
}

class OfferInitial extends OfferState {
  @override
  List<Object?> get props => [];
}

class OfferLoading extends OfferState {
  @override
  List<Object?> get props => [];
}

class OfferLoaded extends OfferState {
  final List<ProductEntity> discountedProducts;

  const OfferLoaded(this.discountedProducts);

  @override
  List<Object?> get props => [discountedProducts];
}

class OfferError extends OfferState {
  final String message;

  const OfferError(this.message);

  @override
  List<Object?> get props => [message];
}
