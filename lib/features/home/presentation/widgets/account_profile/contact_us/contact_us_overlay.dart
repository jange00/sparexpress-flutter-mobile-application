import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Make sure these paths are correct for your project
import 'package:sparexpress/features/home/presentation/view_model/account/contact_us_view_model/contact_us_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/contact_us_view_model/contact_us_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/contact_us_view_model/contact_us_state.dart';


class ContactUsOverlay extends StatefulWidget {
  const ContactUsOverlay({super.key});

  @override
  State<ContactUsOverlay> createState() => _ContactUsOverlayState();
}

class _ContactUsOverlayState extends State<ContactUsOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose(); 
    _messageController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required ColorScheme colorScheme,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: colorScheme.onSurfaceVariant) : null,
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocProvider(
      create: (context) => ContactUsBloc(),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Center(
            child: Dialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420, maxHeight: 680), // Increased height for new field
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocConsumer<ContactUsBloc, ContactUsState>(
                    listener: (context, state) {
                      if (state is ContactUsSuccess) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green[600],
                          ));
                      } else if (state is ContactUsFailure) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text(state.error),
                            backgroundColor: colorScheme.error,
                          ));
                      }
                    },
                    builder: (context, state) {
                      // ** THE FIX IS HERE **
                      // The mainAxisSize property is removed from this Column.
                      // This allows the Column to expand and fill the parent,
                      // giving the Flexible child a defined space to occupy.
                      return Column(
                        children: [
                          _buildHeader(context, textTheme, colorScheme),
                          const SizedBox(height: 24),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: _buildInputDecoration(
                                        labelText: 'Your Name',
                                        colorScheme: colorScheme,
                                        prefixIcon: Icons.person_outline,
                                      ),
                                      validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: _buildInputDecoration(
                                        labelText: 'Your Email',
                                        colorScheme: colorScheme,
                                        prefixIcon: Icons.email_outlined,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return 'Please enter your email';
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Enter a valid email';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // ADDED: The new phone number text field
                                    TextFormField(
                                      controller: _phoneController,
                                      decoration: _buildInputDecoration(
                                        labelText: 'Phone Number',
                                        colorScheme: colorScheme,
                                        prefixIcon: Icons.phone_outlined,
                                      ),
                                      keyboardType: TextInputType.phone,
                                      // No validator makes it optional
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _messageController,
                                      decoration: _buildInputDecoration(
                                        labelText: 'Your Message',
                                        colorScheme: colorScheme,
                                        prefixIcon: Icons.message_outlined,
                                      ),
                                      maxLines: 4,
                                      validator: (v) => v!.isEmpty ? 'Please enter a message' : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          state is ContactUsLoading
                              ? SizedBox(
                                  height: 54,
                                  child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                                )
                              : _buildSubmitButton(context, colorScheme, textTheme),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Send us a Message',
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
    );
  }

  Widget _buildSubmitButton(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<ContactUsBloc>().add(
                  ContactMessageSubmitted(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    message: _messageController.text.trim(),
                    // ADDED: Pass the phone number to the event
                    phoneNumber: _phoneController.text.trim(),
                  ),
                );
          }
        },
        child: const Text('Send Message'),
      ),
    );
  }
}