import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String categoryTitle;

  const CategoryEntity({this.categoryId, required this.categoryTitle});

  @override
  List<Object?> get props => [categoryId, categoryTitle];

  factory CategoryEntity.empty() {
    return const CategoryEntity(categoryId: null, categoryTitle: '');
  }
}
