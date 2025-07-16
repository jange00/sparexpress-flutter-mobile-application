import 'package:flutter/material.dart';

class ChangePasswordCard extends StatelessWidget {
  final VoidCallback onTap;

  const ChangePasswordCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.lock_outline, color: const Color(0xFFFFC107)),
        title: const Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
