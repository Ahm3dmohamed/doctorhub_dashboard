import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/dashboard_home_content.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/dashboard_shared_widgets.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:flutter/material.dart';

class DesktopDashboard extends StatelessWidget {
  final UserEntity user;
  final int selectedIndex;
  final bool sidebarCollapsed;
  final ValueChanged<int> onNavTap;
  final VoidCallback onToggleSidebar;
  final Animation<double> fadeAnimation;

  const DesktopDashboard({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.sidebarCollapsed,
    required this.onNavTap,
    required this.onToggleSidebar,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Animated collapsible sidebar
        AnimatedContainer(
          duration: AppConstants.animNormal,
          width: sidebarCollapsed
              ? AppConstants.sidebarCollapsedWidth
              : AppConstants.sidebarWidth,
          child: DashboardSidebar(
            user: user,
            isCollapsed: sidebarCollapsed,
            onToggle: onToggleSidebar,
          ),
        ),

        // Main content area
        Expanded(
          child: Column(
            children: [
              DashboardTopBar(user: user, onToggleSidebar: onToggleSidebar),
              Expanded(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: DashboardHomeContent(user: user),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
