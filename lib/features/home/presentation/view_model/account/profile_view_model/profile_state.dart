import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final CustomerEntity customer;
  ProfileLoaded(this.customer);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
