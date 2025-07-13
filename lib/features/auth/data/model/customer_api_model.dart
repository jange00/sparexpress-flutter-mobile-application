import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

// dart run build_runner build -d 
part 'customer_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable{
@JsonKey(name: '_id')
  final String? id;

  final String fullname;
  final String email;
  final String? password;
  
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;

  final String role;

  final String? profilePicture;

  const AuthApiModel({
    this.id,
    required this.fullname,
    required this.email,
    this.password,
    required this.phoneNumber,
    this.role = "Customer",
    this.profilePicture,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // To Entity 
  CustomerEntity toEntity() {
    return CustomerEntity(
      customerId: id,
      fullName: fullname,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profilePicture,
      password: password ?? '',
      );
  }

  // From Entity
  factory AuthApiModel.fromEntity (CustomerEntity entity) {
    return AuthApiModel(
      fullname: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profileImage,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props => [id, fullname, email, profilePicture, password];
}