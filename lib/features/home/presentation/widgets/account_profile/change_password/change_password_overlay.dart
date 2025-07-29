import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/change_password/change_password_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/change_password/change_password_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/change_password/change_password_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/change_password/change_password_service.dart';

class ChangePasswordOverlay extends StatefulWidget {
  const ChangePasswordOverlay({super.key});

  @override
  State<ChangePasswordOverlay> createState() => _ChangePasswordOverlayState();
}

class _ChangePasswordOverlayState extends State<ChangePasswordOverlay> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // Helper method for text field decoration to keep the build method clean
  InputDecoration _buildInputDecoration(
      {required String labelText,
      required ColorScheme colorScheme,
      Widget? suffixIcon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      suffixIcon: suffixIcon,
      // Use a filled style for a modern look
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
      // Remove the underline border and use a rounded rectangle
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // No border in default state
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
    );
  }

  Future<void> _handleChangePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await changePassword(
        currentPassword: _currentPassController.text.trim(),
        newPassword: _newPassController.text.trim(),
      );
      setState(() => _isLoading = false);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract theme data for easy access and consistency
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Stack(
      children: [
        // Blur + semi-transparent overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Center(
          child: Dialog(
            backgroundColor: colorScheme.surface,
            // Softer, more modern border radius
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0)),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600, maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: BlocProvider(
                  create: (_) => ChangePasswordBloc(),
                  child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                    listener: (context, state) {
                      if (state is ChangePasswordSuccess) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                                content: Text('Password changed successfully!')),
                          );
                        Navigator.of(context).pop();
                      } else if (state is ChangePasswordFailure) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: colorScheme.error,
                            ),
                          );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header row with title and close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Use theme's typography for the title
                              Text(
                                'Change Password',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: colorScheme.onSurfaceVariant,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Scrollable form area
                          Flexible(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Current Password Field
                                    TextFormField(
                                      controller: _currentPassController,
                                      obscureText: _obscureCurrent,
                                      decoration: _buildInputDecoration(
                                        labelText: 'Current Password',
                                        colorScheme: colorScheme,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureCurrent
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () => setState(() =>
                                              _obscureCurrent = !_obscureCurrent),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your current password';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    // New Password Field
                                    TextFormField(
                                      controller: _newPassController,
                                      obscureText: _obscureNew,
                                      decoration: _buildInputDecoration(
                                        labelText: 'New Password',
                                        colorScheme: colorScheme,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureNew
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () => setState(
                                              () => _obscureNew = !_obscureNew),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a new password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    // Confirm New Password Field
                                    TextFormField(
                                      controller: _confirmPassController,
                                      obscureText: _obscureConfirm,
                                      decoration: _buildInputDecoration(
                                        labelText: 'Confirm New Password',
                                        colorScheme: colorScheme,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirm
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () => setState(() =>
                                              _obscureConfirm = !_obscureConfirm),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your new password';
                                        }
                                        if (value != _newPassController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Submit button or loading indicator
                          state is ChangePasswordLoading
                              ? SizedBox(
                                  // Set a fixed height to prevent layout shifts
                                  height: 54,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : () => _handleChangePassword(context),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(strokeWidth: 3),
                                          )
                                        : const Text('Change Password'),
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}