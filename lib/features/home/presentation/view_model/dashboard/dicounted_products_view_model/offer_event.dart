import 'package:equatable/equatable.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();
}

class LoadDiscountedProducts extends OfferEvent {
  const LoadDiscountedProducts();

  @override
  List<Object?> get props => [];
}
