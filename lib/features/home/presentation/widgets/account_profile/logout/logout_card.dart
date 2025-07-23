import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_event.dart';

class LogoutCard extends StatelessWidget {
  final BuildContext blocContext;
  const LogoutCard({super.key, required this.blocContext});

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.logout, color: const Color(0xFFFFC107), size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        "Confirm Logout",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Are you sure you want to logout from your account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              // Use theme's OutlinedButtonTheme
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              // Use theme's ElevatedButtonTheme
                              onPressed: () {
                                Navigator.of(context).pop();
                                blocContext.read<AccountBloc>().add(LogoutRequested());
                              },
                              child: const Text("Logout"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.logout, color: const Color(0xFFFFC107)),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }
}
