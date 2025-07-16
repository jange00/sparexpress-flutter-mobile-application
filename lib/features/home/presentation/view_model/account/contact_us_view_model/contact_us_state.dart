import 'package:flutter/material.dart';

@immutable
abstract class ContactUsState {}

// The form is ready for input
class ContactUsInitial extends ContactUsState {}

// The user has pressed "Send" and we are waiting for the server
class ContactUsLoading extends ContactUsState {}

// The message was sent successfully
class ContactUsSuccess extends ContactUsState {
  final String message;
  ContactUsSuccess(this.message);
}

// An error occurred during submission
class ContactUsFailure extends ContactUsState {
  final String error;
  ContactUsFailure(this.error);
}