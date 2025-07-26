import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<String> _selectedCountryCode = ValueNotifier('+977');
  final ValueNotifier<bool> _showPassword = ValueNotifier(false);
  final ValueNotifier<bool> _showConfirmPassword = ValueNotifier(false);
  final ValueNotifier<bool> _termsAccepted = ValueNotifier(false);
  final ValueNotifier<File?> _profileImageFile = ValueNotifier(null);
  final ValueNotifier<String?> _uploadedImageUrl = ValueNotifier(null);
  final ValueNotifier<bool> _isImageUploading = ValueNotifier(false);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.request().isDenied ||
        await Permission.camera.request().isRestricted) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (pickedImage != null) {
        final file = File(pickedImage.path);
        _profileImageFile.value = file;
        _uploadImage(context, file);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _showErrorSnackBar(context, 'Failed to pick image. Please try again.');
    }
  }

  Future<void> _uploadImage(BuildContext context, File file) async {
    try {
      debugPrint('Storing image file for later upload: ${file.path}');
      // For registration, we'll store the image locally and upload it during registration
      // This avoids authentication issues during signup
      context.read<RegisterViewModel>().add(UploadImageEvent(file: file));
    } catch (e) {
      debugPrint('Error uploading image: $e');
      _showErrorSnackBar(context, 'Failed to upload image. Please try again.');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select Profile Picture',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to add your profile picture',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    subtitle: 'Take a photo',
                    onTap: () {
                      _checkCameraPermission().then(
                        (_) => _pickImage(context, ImageSource.camera),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    subtitle: 'Choose from gallery',
                    onTap: () {
                      _pickImage(context, ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: const Color(0xFFFFC107)),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: 'Enter your $label',
      prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  void _submitForm(BuildContext context) {
    if (!_termsAccepted.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              const Text("Please accept the terms & conditions"),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<RegisterViewModel>().add(
        RegisterCustomerEvent(
          context: context,
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          debugPrint('Register state changed - isLoading: ${state.isLoading}, isSuccess: ${state.isSuccess}, hasImage: ${state.profileImageFile != null}');
          
          // Handle image selection (not upload during registration)
          if (state.profileImageFile != null && _profileImageFile.value != state.profileImageFile) {
            debugPrint('Image file stored in state: ${state.profileImageFile!.path}');
            _profileImageFile.value = state.profileImageFile;
            _isImageUploading.value = false;
          }
          
          // Handle loading state during registration
          if (state.isLoading) {
            debugPrint('Setting image uploading to true');
            _isImageUploading.value = true;
          } else {
            // Reset loading state when not loading
            debugPrint('Setting image uploading to false');
            _isImageUploading.value = false;
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, size: 24),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Logo and Title
                  Text.rich(
                    TextSpan(
                      text: "Spare",
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      children: [
                        TextSpan(
                          text: "Xpress",
                          style: TextStyle(color: const Color(0xFFFFC107)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create your account and start shopping",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Animation
                  SizedBox(
                    height: 160,
                    width: 280,
                    child: Lottie.asset(
                      'assets/animation/sign_in_animation.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    "Create Account",
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Profile Picture Picker
                  GestureDetector(
                    onTap: () => _showImagePickerBottomSheet(context),
                    child: ValueListenableBuilder3<File?, String?, bool>(
                      first: _profileImageFile,
                      second: _uploadedImageUrl,
                      third: _isImageUploading,
                      builder: (_, file, uploadedUrl, isUploading, __) => Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _getProfileImage(file, uploadedUrl),
                            child: _buildProfileImageChild(file, uploadedUrl, isUploading),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: isUploading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isImageUploading,
                    builder: (_, isUploading, __) => Text(
                      isUploading ? "Processing..." : "Tap to add profile picture (optional)",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: isUploading ? const Color(0xFFFFC107) : Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Full Name Field
                  TextFormField(
                    controller: _fullNameController,
                    decoration: _buildInputDecoration("Full Name", Icons.person_outline),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: _buildInputDecoration("Email", Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone Field with Country Code
                  Row(
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: _selectedCountryCode,
                        builder: (context, code, _) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<String>(
                            value: code,
                            underline: const SizedBox(),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                            items: ['+977', '+91', '+1', '+44', '+86', '+81']
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) _selectedCountryCode.value = val;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: _buildInputDecoration("Phone Number", Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.trim().length < 8) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  ValueListenableBuilder<bool>(
                    valueListenable: _showPassword,
                    builder: (_, show, __) => TextFormField(
                      controller: _passwordController,
                      obscureText: !show,
                      decoration: _buildInputDecoration("Password", Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            show ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () => _showPassword.value = !show,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  ValueListenableBuilder<bool>(
                    valueListenable: _showConfirmPassword,
                    builder: (_, show, __) => TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !show,
                      decoration: _buildInputDecoration("Confirm Password", Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            show ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () => _showConfirmPassword.value = !show,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Terms and Conditions
                  ValueListenableBuilder<bool>(
                    valueListenable: _termsAccepted,
                    builder: (_, accepted, __) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accepted ? const Color(0xFFFFC107) : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: accepted,
                            onChanged: (val) => _termsAccepted.value = val ?? false,
                            activeColor: const Color(0xFFFFC107),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "I agree to the ",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      color: const Color(0xFFFFC107),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      color: const Color(0xFFFFC107),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  BlocBuilder<RegisterViewModel, RegisterState>(
                    builder: (context, state) => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : Text(
                                "Create Account",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFFFC107),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage(File? file, String? uploadedUrl) {
    if (uploadedUrl != null) {
      return NetworkImage(uploadedUrl);
    } else if (file != null) {
      return FileImage(file);
    }
    return null;
  }

  Widget? _buildProfileImageChild(File? file, String? uploadedUrl, bool isUploading) {
    if (isUploading) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
      );
    } else if (file == null && uploadedUrl == null) {
      return Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[400],
      );
    }
    return null;
  }
}

// Custom ValueListenableBuilder for 3 values
class ValueListenableBuilder3<T1, T2, T3> extends StatelessWidget {
  final ValueListenable<T1> first;
  final ValueListenable<T2> second;
  final ValueListenable<T3> third;
  final Widget Function(BuildContext context, T1 first, T2 second, T3 third, Widget? child) builder;

  const ValueListenableBuilder3({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T1>(
      valueListenable: first,
      builder: (context, firstValue, child) {
        return ValueListenableBuilder<T2>(
          valueListenable: second,
          builder: (context, secondValue, child) {
            return ValueListenableBuilder<T3>(
              valueListenable: third,
              builder: (context, thirdValue, child) {
                return builder(context, firstValue, secondValue, thirdValue, child);
              },
            );
          },
        );
      },
    );
  }
}
