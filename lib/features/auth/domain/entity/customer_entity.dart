import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String? customerId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String password;

  const CustomerEntity({
    this.customerId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.password,
  });

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
