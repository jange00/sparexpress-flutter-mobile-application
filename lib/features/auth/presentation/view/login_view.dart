import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/auth/presentation/view/register_view.dart';
import 'package:sparexpress/features/auth/presentation/view/forgot_password_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:local_auth/local_auth.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);
  final ValueNotifier<bool> _showPassword = ValueNotifier(false);

  final _gap = const SizedBox(height: 20);
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  StreamSubscription<int>? _proximitySubscription;
  bool _isProximityDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _proximitySubscription = ProximitySensor.events.listen(_onProximityEvent);
  }

  void _onProximityEvent(int event) {
    if (event > 0 && !_isProximityDialogShowing) {
      _showProximityExitDialog();
    }
  }

  void _showProximityExitDialog() {
    _isProximityDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _isProximityDialogShowing = false;
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _isProximityDialogShowing = false;
              Future.delayed(const Duration(milliseconds: 200), () {
                try {
                  SystemNavigator.pop();
                } catch (_) {
                  exit(0);
                }
              });
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _proximitySubscription?.cancel();
    _proximitySubscription = null;
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!canCheck || !isDeviceSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available on this device.')),
        );
        return;
      }
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      // Require Face ID on iOS
      if (Theme.of(context).platform == TargetPlatform.iOS &&
          !availableBiometrics.contains(BiometricType.face)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Face ID is not available on this device.')),
        );
        return;
      }
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication successful!')),
        );
        // TODO: You can trigger a login event here if you want to auto-login.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: BlocBuilder<LoginViewModel, LoginState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
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
                const SizedBox(height: 2),
                SizedBox(
                  height: 200,
                  width: 400,
                  child: Lottie.asset('assets/animation/sign_in_animation.json'),
                ),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: const ValueKey('email'),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      _gap,
                      ValueListenableBuilder<bool>(
                        valueListenable: _showPassword,
                        builder: (context, show, _) {
                          return TextFormField(
                            key: const ValueKey('password'),
                            controller: _passwordController,
                            obscureText: !show,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  show ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () => _showPassword.value = !show,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _rememberMe,
                            builder: (context, value, _) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: value,
                                    onChanged: (val) => _rememberMe.value = val ?? false,
                                    activeColor: const Color(0xFFFFC107),
                                  ),
                                  const Text(
                                    "Remember me",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordView(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xFFFFC107),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _gap,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print('Sign In button pressed with:');
                              print('Email: ${_emailController.text}');
                              print('Password: ${_passwordController.text}');

                              context.read<LoginViewModel>().add(
                                    LoginWithEmailAndPasswordEvent(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );

                                  
                            }
                          },
                          icon: const Icon(Icons.login),
                          label: const Text("Sign In"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.fingerprint, size: 28),
                          label: const Text('Login with Biometrics'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => _authenticateWithBiometrics(context),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F2),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              elevation: 3,
                            ),
                            child: const FaIcon(FontAwesomeIcons.google, color: Color(0xFFDB4437), size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<RegisterViewModel>.value(
                                value: serviceLocator<RegisterViewModel>(),
                                child: RegisterView(),
                              ),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "New user? ",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Create an account →",
                                style: TextStyle(
                                  color: const Color(0xFFFFC107),
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
            );
          },
        ),
      ),
    );
  }
}
