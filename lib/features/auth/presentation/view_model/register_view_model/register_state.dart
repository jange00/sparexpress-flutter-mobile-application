import 'package:equatable/equatable.dart';
import 'dart:io';

class RegisterState extends Equatable{
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;
  final File? profileImageFile;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    required this.imageName,
    required this.profileImageFile,
  });

  const RegisterState.initial()
    : isLoading = false,
      isSuccess = false,
      imageName = null,
      profileImageFile = null;

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
    File? profileImageFile,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading, 
      isSuccess: isSuccess ?? this.isSuccess, 
      imageName: imageName ?? this.imageName,
      profileImageFile: profileImageFile ?? this.profileImageFile,
      );
  }

  @override 
  List<Object?> get props => [isLoading, isSuccess, imageName, profileImageFile];
}