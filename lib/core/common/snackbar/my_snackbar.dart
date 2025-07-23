import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context, {
  required String message,
  IconData? icon,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 2),
}) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
