import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

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
  final ValueNotifier<File?> _profileImage = ValueNotifier(null);

  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.request().isDenied ||
        await Permission.camera.request().isRestricted) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        final file = File(pickedImage.path);
        _profileImage.value = file;
        context.read<RegisterViewModel>().add(UploadImageEvent(file: file));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 20),
                Text(
                  'Select Profile Picture',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildImageSourceButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        _checkCameraPermission().then(
                          (_) => _pickImage(context, ImageSource.camera),
                        );
                        Navigator.pop(context);
                      },
                    ),
                    _buildImageSourceButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        _checkCameraPermission().then(
                          (_) => _pickImage(context, ImageSource.gallery),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFFFFC107)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  void _submitForm(BuildContext context) {
    if (!_termsAccepted.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the terms & conditions"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<RegisterViewModel>().add(
        RegisterCustomerEvent(
          context: context,
          fullName: _fullNameController.text,
          phoneNumber: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RegisterViewModel, RegisterState>(
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text.rich(
                          TextSpan(
                            text: "Spare",
                            style: GoogleFonts.montserrat(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            children: [
                              TextSpan(
                                text: "Xpress",
                                style: TextStyle(
                                  color: const Color(0xFFFFC107),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Create your account and start shopping",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Profile Picker
                        GestureDetector(
                          onTap: () => _showImagePickerBottomSheet(context),
                          child: ValueListenableBuilder<File?>(
                            valueListenable: _profileImage,
                            builder:
                                (_, file, __) => CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage:
                                      file != null ? FileImage(file) : null,
                                  child:
                                      file == null
                                          ? const Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                            color: Colors.grey,
                                          )
                                          : null,
                                ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: _fullNameController,
                          decoration: _inputDecoration("Full Name"),
                          validator:
                              (val) =>
                                  val == null || val.isEmpty
                                      ? "Enter your full name"
                                      : null,
                        ),
                        spacing,
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration("Email"),
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (val) =>
                                  val == null || !val.contains('@')
                                      ? "Enter a valid email"
                                      : null,
                        ),
                        spacing,
                        Row(
                          children: [
                            ValueListenableBuilder<String>(
                              valueListenable: _selectedCountryCode,
                              builder:
                                  (context, code, _) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButton<String>(
                                      value: code,
                                      underline: const SizedBox(),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      items:
                                          ['+977', '+91', '+1', '+44']
                                              .map(
                                                (c) => DropdownMenuItem(
                                                  value: c,
                                                  child: Text(c),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) {
                                        if (val != null)
                                          _selectedCountryCode.value = val;
                                      },
                                    ),
                                  ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                decoration: _inputDecoration("Phone"),
                                keyboardType: TextInputType.phone,
                                validator:
                                    (val) =>
                                        val == null || val.length < 6
                                            ? "Enter valid phone"
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        spacing,

                        // Password
                        ValueListenableBuilder<bool>(
                          valueListenable: _showPassword,
                          builder:
                              (_, show, __) => TextFormField(
                                controller: _passwordController,
                                obscureText: !show,
                                decoration: _inputDecoration(
                                  "Password",
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      show
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed:
                                        () => _showPassword.value = !show,
                                  ),
                                ),
                                validator:
                                    (val) =>
                                        val != null && val.length < 6
                                            ? "Password must be at least 6 characters"
                                            : null,
                              ),
                        ),
                        spacing,

                        // Confirm Password
                        ValueListenableBuilder<bool>(
                          valueListenable: _showConfirmPassword,
                          builder:
                              (_, show, __) => TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !show,
                                decoration: _inputDecoration(
                                  "Confirm Password",
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      show
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed:
                                        () =>
                                            _showConfirmPassword.value = !show,
                                  ),
                                ),
                                validator:
                                    (val) =>
                                        val != _passwordController.text
                                            ? "Passwords do not match"
                                            : null,
                              ),
                        ),
                        spacing,

                        ValueListenableBuilder<bool>(
                          valueListenable: _termsAccepted,
                          builder:
                              (_, accepted, __) => Row(
                                children: [
                                  Checkbox(
                                    value: accepted,
                                    onChanged:
                                        (val) =>
                                            _termsAccepted.value = val ?? false,
                                    activeColor: const Color(0xFFFFC107),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "I agree to the Terms & Conditions",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                        ),
                        spacing,

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _submitForm(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, size: 32),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
