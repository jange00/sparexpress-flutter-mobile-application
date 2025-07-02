// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['_id'] as String?,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String? ?? "Customer",
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'profilePicture': instance.profilePicture,
    };
