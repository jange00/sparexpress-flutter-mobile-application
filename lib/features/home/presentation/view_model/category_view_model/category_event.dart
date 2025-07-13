import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();

  @override
  List<Object?> get props => [];
}