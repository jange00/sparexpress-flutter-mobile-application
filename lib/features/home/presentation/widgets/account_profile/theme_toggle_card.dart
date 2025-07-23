import 'package:flutter/material.dart';

class ThemeToggleCard extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeToggleCard({
    Key? key,
    required this.isDarkMode,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: theme.colorScheme.primary,
        ),
        title: const Text(
          "Dark Mode",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
        onTap: () => onChanged(!isDarkMode),
      ),
    );
  }
} 