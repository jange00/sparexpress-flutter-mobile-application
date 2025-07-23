import 'package:flutter/material.dart';

class ContactUsCard extends StatelessWidget {
  final VoidCallback onTap;

  const ContactUsCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(
          Icons.headset_mic_outlined,
          color: theme.colorScheme.primary,
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        onTap: onTap,
      ),
    );
  }
}