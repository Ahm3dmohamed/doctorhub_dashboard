import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'dashboard_shared_widgets.dart';

/// Collapsible sidebar for desktop and mobile drawer navigation.
class DashboardSidebar extends StatelessWidget {
  final UserEntity user;
  final bool isCollapsed;
  final VoidCallback onToggle;

  const DashboardSidebar({
    super.key,
    required this.user,
    required this.isCollapsed,
    required this.onToggle,
  });

  List<DashboardNavItem> _buildNavItems(UserRole role) => [
        const DashboardNavItem(
          icon: Icons.grid_view_rounded,
          label: 'Dashboard',
          route: AppRoutes.dashboard,
        ),
        if (role == UserRole.superAdmin || role == UserRole.doctor)
          const DashboardNavItem(
            icon: Icons.people_rounded,
            label: 'Patients',
            route: AppRoutes.patients,
          ),
        if (role == UserRole.superAdmin || role == UserRole.doctor)
          const DashboardNavItem(
            icon: Icons.calendar_month_rounded,
            label: 'Appointments',
            route: AppRoutes.appointments,
          ),
        if (role == UserRole.superAdmin || role == UserRole.clinicManager)
          const DashboardNavItem(
            icon: Icons.local_hospital_rounded,
            label: 'Clinics',
            route: AppRoutes.clinics,
          ),
        if (role == UserRole.superAdmin)
          const DashboardNavItem(
            icon: Icons.medical_services_rounded,
            label: 'Doctors',
            route: AppRoutes.doctors,
          ),
        if (role == UserRole.superAdmin || role == UserRole.doctor)
          const DashboardNavItem(
            icon: Icons.medical_information_rounded,
            label: 'Medical Records',
            route: AppRoutes.medicalRecords,
          ),
        if (role == UserRole.superAdmin || role == UserRole.doctor)
          const DashboardNavItem(
            icon: Icons.medication_rounded,
            label: 'Prescriptions',
            route: AppRoutes.prescriptions,
          ),
        const DashboardNavItem(
          icon: Icons.rate_review_rounded,
          label: 'Reviews',
          route: AppRoutes.reviews,
        ),
        const DashboardNavItem(
          icon: Icons.notifications_rounded,
          label: 'Notifications',
          route: AppRoutes.notifications,
        ),
        if (role == UserRole.superAdmin || role == UserRole.clinicManager)
          const DashboardNavItem(
            icon: Icons.analytics_rounded,
            label: 'Reports & Analytics',
            route: AppRoutes.reports,
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navItems = _buildNavItems(user.role);
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          _SidebarLogo(isCollapsed: isCollapsed, onToggle: onToggle),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.space3,
                horizontal: AppConstants.space3,
              ),
              itemCount: navItems.length,
              itemBuilder: (context, i) {
                final item = navItems[i];
                final isSelected = item.route != null && currentLocation == item.route;
                return _SidebarNavItem(
                  item: item,
                  isSelected: isSelected,
                  isCollapsed: isCollapsed,
                  onTap: () {
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                    if (item.route != null && currentLocation != item.route) {
                      context.go(item.route!);
                    }
                  },
                );
              },
            ),
          ),
          _SidebarUserFooter(user: user, isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _SidebarLogo extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;

  const _SidebarLogo({required this.isCollapsed, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppConstants.topBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 16 : AppConstants.space5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: AppConstants.space3),
            Expanded(
              child: Text(
                'DoctorHub',
                style: AppTypography.brand(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              isCollapsed
                  ? Icons.chevron_right_rounded
                  : Icons.chevron_left_rounded,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarUserFooter extends StatelessWidget {
  final UserEntity user;
  final bool isCollapsed;

  const _SidebarUserFooter({
    required this.user,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(isCollapsed ? 12 : AppConstants.space4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: isCollapsed
          ? DashboardUserAvatar(user: user, size: 36)
          : DashboardUserProfileTile(user: user),
    );
  }
}

/// Individual sidebar navigation item with hover and selection states.
class _SidebarNavItem extends StatefulWidget {
  final DashboardNavItem item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: widget.isCollapsed ? widget.item.label : '',
      preferBelow: false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppConstants.animFast,
            margin: const EdgeInsets.only(bottom: 2),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 12 : AppConstants.space3,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : _isHovered
                      ? (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04))
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  size: 18,
                  color: widget.isSelected
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
                if (!widget.isCollapsed) ...[
                  const SizedBox(width: AppConstants.space3),
                  Text(
                    widget.item.label,
                    style: AppTypography.bodyMd(
                      color: widget.isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                      weight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation bar for mobile layout with route-aware selection and navigation.
class DashboardBottomNavBar extends StatelessWidget {
  const DashboardBottomNavBar({super.key});

  int _getSelectedIndex(String location) {
    if (location.startsWith(AppRoutes.patients)) return 1;
    if (location.startsWith(AppRoutes.appointments)) return 2;
    if (location.startsWith(AppRoutes.reports)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.patients);
        break;
      case 2:
        context.go(AppRoutes.appointments);
        break;
      case 3:
        context.go(AppRoutes.reports);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _getSelectedIndex(location);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (idx) => _onItemTapped(context, idx),
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
      selectedLabelStyle: AppTypography.labelSm(),
      unselectedLabelStyle: AppTypography.labelSm(),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_rounded),
          label: 'Patients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_rounded),
          label: 'Reports',
        ),
      ],
    );
  }
}
