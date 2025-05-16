import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCountryCode = '+977';
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _termsAccepted = false;
  File? _profileImage;

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the terms & conditions"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      debugPrint("Submitted: ${_fullNameController.text}");
    }
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

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Branding (SpareXpress)
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
                            style: TextStyle(color: const Color(0xFFFFC107)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Text(
                    //   "Welcome Back!",
                    //   style: GoogleFonts.montserrat(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.grey[800],
                    //   ),
                    // ),
                    const SizedBox(height: 2),
                    Text(
                      "Sign up account and start shopping",
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
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Profile Picker
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      decoration: _inputDecoration("Full Name"),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter your full name" : null,
                    ),
                    spacing,

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration("Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val == null || !val.contains('@') ? "Enter a valid email" : null,
                    ),
                    spacing,

                    // Phone with Country Code
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: ['+977', '+91', '+1', '+44']
                                .map((code) => DropdownMenuItem(
                                      value: code,
                                      child: Text(code),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedCountryCode = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: _inputDecoration("Phone"),
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                val == null || val.length < 6 ? "Enter valid phone" : null,
                          ),
                        ),
                      ],
                    ),
                    spacing,

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: _inputDecoration("Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      validator: (val) => val != null && val.length < 6
                          ? "Password must be at least 6 characters"
                          : null,
                    ),
                    spacing,

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      decoration: _inputDecoration("Confirm Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(
                              () => _showConfirmPassword = !_showConfirmPassword),
                        ),
                      ),
                      validator: (val) => val != _passwordController.text
                          ? "Passwords do not match"
                          : null,
                    ),
                    spacing,

                    // Terms & Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (val) =>
                              setState(() => _termsAccepted = val ?? false),
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
                    spacing,

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
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
                          "Sign Up",
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

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
