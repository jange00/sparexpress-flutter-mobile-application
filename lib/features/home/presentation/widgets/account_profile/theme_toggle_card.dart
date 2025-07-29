import 'package:flutter/material.dart';

class ThemeToggleCard extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeToggleCard({
    Key? key,
    required this.themeMode,
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
          themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_auto,
          color: theme.colorScheme.primary,
        ),
        title: const Text(
          "Theme",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: DropdownButton<ThemeMode>(
          value: themeMode,
          underline: const SizedBox(),
          onChanged: (mode) {
            if (mode != null) onChanged(mode);
          },
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('Auto'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark'),
            ),
          ],
        ),
      ),
    );
  }
} 