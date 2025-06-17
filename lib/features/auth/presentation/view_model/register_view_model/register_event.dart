import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
sealed class RegisterEvent {}

class UploadImageEvent extends RegisterEvent {
  final File file;

  UploadImageEvent({required this.file});
}

class RegisterCustomerEvent extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? profileImage;

  RegisterCustomerEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profileImage,
  });
}