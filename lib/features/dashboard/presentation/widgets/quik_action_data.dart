import 'package:flutter/material.dart';

class QuickActionData {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  const QuickActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
}
