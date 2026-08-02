import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/glass_card.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/left_branding_panel.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;

  const DesktopLayout({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left branding panel
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.space16),
            child: LeftBrandingPanel(),
          ),
        ),

        // Right form panel
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.space6),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: GlassCard(child: child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
