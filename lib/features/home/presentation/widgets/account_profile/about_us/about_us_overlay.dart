import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sparexpress/app/constant/about_us_data.dart' as AboutUsData;

class AboutUsOverlay extends StatelessWidget {
  const AboutUsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            color: Colors.black.withOpacity(0.3), // semi-transparent overlay
          ),
        ),
        Center(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'About Us',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Features',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            ...AboutUsData.features.map((f) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(f.icon, size: 32, color: Colors.amber[700]),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              f.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              f.description,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                            if (f.stats != null)
                                              Text(
                                                f.stats!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(height: 32),
                            const Text(
                              'Additional Benefits',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            ...AboutUsData.additionalBenefits.map((b) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(b.icon, size: 24, color: Colors.amber[700]),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(b.title,
                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text(b.description,
                                              style: const TextStyle(fontSize: 13)),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(height: 32),
                            const Text(
                              'Trust Indicators',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: AboutUsData.trustIndicators.map((t) {
                                return Column(
                                  children: [
                                    Text(
                                      t.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.amber),
                                    ),
                                    Text(
                                      t.label,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
