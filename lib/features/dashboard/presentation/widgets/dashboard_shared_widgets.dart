import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../../../notifications/presentation/cubit/notification_state.dart';

/// Top navigation bar displayed in the desktop layout.
class DashboardTopBar extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onToggleSidebar;

  const DashboardTopBar({
    super.key,
    required this.user,
    this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppConstants.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Global Search bar
          InkWell(
            onTap: () => _showGlobalSearchModal(context),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: Container(
              height: 38,
              width: 360,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search patients, doctors, appointments...',
                      style: AppTypography.bodySm(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      'Ctrl+K',
                      style: AppTypography.labelSm(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          const DashboardNotificationBell(),

          const SizedBox(width: AppConstants.space4),

          DashboardUserAvatar(user: user),
        ],
      ),
    );
  }

  void _showGlobalSearchModal(BuildContext context) {
    showSearch(
      context: context,
      delegate: _GlobalSearchDelegate(),
    );
  }
}

class _GlobalSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final options = [
      {'title': 'Patients Directory', 'subtitle': 'View & search all patient EMR files', 'route': AppRoutes.patients, 'icon': Icons.people_rounded},
      {'title': 'Appointments & Schedule', 'subtitle': 'Manage patient consultations', 'route': AppRoutes.appointments, 'icon': Icons.calendar_month_rounded},
      {'title': 'Medical Records', 'subtitle': 'Diagnoses, lab results and EHR history', 'route': AppRoutes.medicalRecords, 'icon': Icons.medical_information_rounded},
      {'title': 'Prescriptions Management', 'subtitle': 'Issue and track e-prescriptions', 'route': AppRoutes.prescriptions, 'icon': Icons.medication_rounded},
      {'title': 'Clinics Directory', 'subtitle': 'Manage clinic locations & working hours', 'route': AppRoutes.clinics, 'icon': Icons.local_hospital_rounded},
      {'title': 'Doctors Directory', 'subtitle': 'Manage medical staff and specialties', 'route': AppRoutes.doctors, 'icon': Icons.medical_services_rounded},
      {'title': 'Reports & Analytics', 'subtitle': 'Executive revenue and KPI reports', 'route': AppRoutes.reports, 'icon': Icons.analytics_rounded},
      {'title': 'Notifications Center', 'subtitle': 'View broadcast notices and alerts', 'route': AppRoutes.notifications, 'icon': Icons.notifications_rounded},
    ];

    final filtered = query.isEmpty
        ? options
        : options.where((o) => (o['title'] as String).toLowerCase().contains(query.toLowerCase()) || (o['subtitle'] as String).toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, i) {
          final item = filtered[i];
          return ListTile(
            leading: Icon(item['icon'] as IconData, color: AppColors.primary),
            title: Text(item['title'] as String, style: AppTypography.headingSm()),
            subtitle: Text(item['subtitle'] as String, style: AppTypography.bodySm()),
            onTap: () {
              close(context, null);
              context.go(item['route'] as String);
            },
          );
        },
      ),
    );
  }
}

/// Notification bell icon with real unread count badge.
class DashboardNotificationBell extends StatelessWidget {
  const DashboardNotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unreadCount = state is NotificationLoaded ? state.unreadCount : 0;

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 22),
              onPressed: () => context.go(AppRoutes.notifications),
              tooltip: 'Notifications',
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            if (unreadCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Circular avatar showing the user's initials with a gradient background.
class DashboardUserAvatar extends StatelessWidget {
  final UserEntity user;
  final double size;

  const DashboardUserAvatar({super.key, required this.user, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          user.initials,
          style: AppTypography.labelMd(color: Colors.white),
        ),
      ),
    );
  }
}

/// Expandable user profile tile shown at the bottom of the sidebar.
/// Includes a popup menu with a sign-out option.
class DashboardUserProfileTile extends StatelessWidget {
  final UserEntity user;

  const DashboardUserProfileTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton(
      child: Row(
        children: [
          DashboardUserAvatar(user: user),
          const SizedBox(width: AppConstants.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  style: AppTypography.bodyMd(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    weight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.role.displayName,
                  style: AppTypography.labelSm(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          onTap: () => context.read<AuthCubit>().logout(),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
              const SizedBox(width: 10),
              Text('Sign Out', style: AppTypography.bodyMd(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Role badge displayed in the welcome header.
class DashboardRoleBadge extends StatelessWidget {
  final UserRole role;

  const DashboardRoleBadge({super.key, required this.role});

  Color get _color => switch (role) {
        UserRole.superAdmin => AppColors.superAdminColor,
        UserRole.doctor => AppColors.doctorColor,
        UserRole.clinicManager => AppColors.clinicManagerColor,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(role.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(role.displayName, style: AppTypography.labelMd(color: _color)),
        ],
      ),
    );
  }
}

/// Welcome greeting shown at the top of the dashboard home content.
class DashboardWelcomeHeader extends StatelessWidget {
  final UserEntity user;

  const DashboardWelcomeHeader({super.key, required this.user});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$_greeting, ',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    TextSpan(
                      text: user.name.split(' ').first,
                      style: AppTypography.headingXl(color: AppColors.primary),
                    ),
                    TextSpan(text: ' 👋', style: AppTypography.headingXl()),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Here's what's happening at your clinic today",
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        DashboardRoleBadge(role: user.role),
      ],
    );
  }
}

/// Go-router navigation item model used by the sidebar and bottom nav bar.
class DashboardNavItem {
  final IconData icon;
  final String label;
  final String? route;

  const DashboardNavItem({
    required this.icon,
    required this.label,
    this.route,
  });
}
