import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;

  const MobileLayout({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.space6),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: slideAnimation, child: child),
      ),
    );
  }
}
