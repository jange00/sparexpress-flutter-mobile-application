import 'package:flutter/material.dart';

@immutable
abstract class ContactUsEvent {}

// Event dispatched when the user presses the "Send Message" button
class ContactMessageSubmitted extends ContactUsEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String message;

  ContactMessageSubmitted({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.message,
  });
}