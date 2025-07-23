import 'package:flutter/material.dart';

class Feature {
  final IconData icon;
  final String title;
  final String description;
  final String? stats;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    this.stats,
  });
}

class Benefit {
  final IconData icon;
  final String title;
  final String description;

  Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class TrustIndicator {
  final String value;
  final String label;

  TrustIndicator({
    required this.value,
    required this.label,
  });
}

final List<Feature> features = [
  Feature(
    icon: Icons.shield,
    title: "100% Genuine Parts",
    description: "All our auto and computer parts are authentic with manufacturer warranty",
    stats: "10,000+ Verified Products",
  ),
  Feature(
    icon: Icons.local_shipping,
    title: "Fast & Secure Delivery",
    description: "Free shipping on orders over \$99 with same-day dispatch",
    stats: "98% On-Time Delivery",
  ),
  Feature(
    icon: Icons.headset_mic,
    title: "24/7 Expert Support",
    description: "Technical assistance and support whenever you need it",
    stats: "15min Avg Response",
  ),
  Feature(
    icon: Icons.inventory_2,
    title: "Secure Packaging",
    description: "Double-layer protective packaging for all sensitive parts",
    stats: "99.9% Safe Arrival",
  ),
];

final List<Benefit> additionalBenefits = [
  Benefit(icon: Icons.thumb_up, title: "Quality Guarantee", description: "30-day return policy"),
  Benefit(icon: Icons.autorenew, title: "Easy Returns", description: "Hassle-free process"),
  Benefit(icon: Icons.account_balance_wallet, title: "Secure Payment", description: "Multiple payment options"),
  Benefit(icon: Icons.access_time, title: "Price Match", description: "Best price guaranteed"),
];

final List<TrustIndicator> trustIndicators = [
  TrustIndicator(value: "50K+", label: "Happy Customers"),
  TrustIndicator(value: "100K+", label: "Parts Delivered"),
  TrustIndicator(value: "4.9", label: "Customer Rating"),
];
