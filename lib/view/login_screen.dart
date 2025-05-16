import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparexpress/common/common_snackbar.dart';
import 'package:sparexpress/view/dashboard_screen.dart';
import 'package:sparexpress/view/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String loginMethod = "email";
  bool showPassword = false;
  bool rememberMe = false;

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _identifierController.text = "";
  }

  void toggleLoginMethod(String method) {
    setState(() {
      loginMethod = method;
      _identifierController.text = method == "phone" ? "+977 " : "";
    });
  }

  void handleLogin() {
  if (!_formKey.currentState!.validate()) {
    showMySnackbar(
      context: context,
      content: "Please fill all the fields correctly.",
      color: Colors.red,
    );
    return;
  }

  final identifier = _identifierController.text.trim();
  final password = _passwordController.text;

  // Accept both email ("admin") and phone ("+977 admin") style
  final validAdminIdentifiers = ["admin", "+977 9860579795"];

  if (validAdminIdentifiers.contains(identifier.toLowerCase()) &&
      password == "admin") {
    showMySnackbar(context: context, content: "Login Success");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  DashboardScreen()),
    );
  } else {
    showMySnackbar(
      context: context,
      content: "Invalid credentials",
      color: Colors.red,
    );
  }

  debugPrint(
    'Logging in using $loginMethod: $identifier, password: $password',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
             const SizedBox(height: 30),
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

            Text(
              "Welcome Back!",
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Sign in to access your account and start shopping",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Toggle between email/phone login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  ["email", "phone"].map((method) {
                    final isActive = loginMethod == method;
                    return GestureDetector(
                      onTap: () => toggleLoginMethod(method),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? const Color(0xFFFFC107)
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              method == "email"
                                  ? Icons.email_outlined
                                  : Icons.phone_outlined,
                              size: 18,
                              color: isActive ? Colors.white : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              method[0].toUpperCase() + method.substring(1),
                              style: TextStyle(
                                color:
                                    isActive ? Colors.white : Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email or Phone input field with updated decoration
                  TextFormField(
                    controller: _identifierController,
                    keyboardType:
                        loginMethod == "phone"
                            ? TextInputType.phone
                            : TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      loginMethod == "email" ? "Email" : "Phone",
                    ).copyWith(
                      prefixIcon: Icon(
                        loginMethod == "email" ? Icons.email : Icons.phone,
                        color: Colors.grey[600],
                      ),
                      hintText:
                          loginMethod == "email"
                              ? "Enter your email"
                              : "+977 XXXXXXXX",
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 20),

                  // Password input field with updated decoration
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !showPassword,
                    decoration: _inputDecoration(
                      "Password"
                      ).copyWith(
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                          
                        ),
                        onPressed:
                            () => setState(() => showPassword = !showPassword),
                      ),
                      // hintText: 
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),

                  // Remember me + Forgot password row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged:
                                (val) => setState(() => rememberMe = val!),
                            activeColor: const Color(0xFFFFC107),
                          ),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot password
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Color(0xFFFFC107)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        handleLogin();
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Sign In"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

// Professional Social Icon Buttons (Icons only)
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Facebook
    ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1877F2), // Official FB blue
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: const FaIcon(
        FontAwesomeIcons.facebookF,
        color: Colors.white,
        size: 20,
      ),
    ),
    const SizedBox(width: 20),

    // Google
    ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: 3,
      ),
      child: const FaIcon(
        FontAwesomeIcons.google,
        color: Color(0xFFDB4437), // Google Red
        size: 20,
      ),
    ),
  ],
),


                  const SizedBox(height: 20),

                  // Sign Up link
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "New user? ",
                        
                        style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,),
                        children: [
                          TextSpan(
                            text: "Create an account →",
                            style: TextStyle(
                              color: const Color(0xFFFFC107,),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
