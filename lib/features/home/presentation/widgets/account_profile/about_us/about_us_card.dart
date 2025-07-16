import 'package:flutter/material.dart';
import 'about_us_overlay.dart';

class AboutUsCard extends StatelessWidget {
  const AboutUsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.info_outline, color: const Color(0xFFFFC107)),
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => const AboutUsOverlay(),
          );
        },
      ),
    );
  }
}
