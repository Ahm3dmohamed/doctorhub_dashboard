import 'package:flutter/material.dart';

class StatCardData {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final LinearGradient gradient;
  final String route;

  const StatCardData({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.gradient,
    required this.route,
  });
}
