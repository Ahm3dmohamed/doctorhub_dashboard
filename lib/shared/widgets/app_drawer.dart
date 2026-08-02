import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

class AppDrawer extends StatelessWidget {
  final UserEntity user;
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.user,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.space3),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DoctorHub',
                      style: AppTypography.headingMd(color: Colors.white),
                    ),
                    Text(
                      user.role.displayName,
                      style: AppTypography.labelSm(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _DrawerTile(
                  icon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  route: AppRoutes.dashboard,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.medical_services_rounded,
                  label: 'Doctors',
                  route: AppRoutes.doctors,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.local_hospital_rounded,
                  label: 'Clinics',
                  route: AppRoutes.clinics,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.people_rounded,
                  label: 'Patients',
                  route: AppRoutes.patients,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.calendar_month_rounded,
                  label: 'Appointments',
                  route: AppRoutes.appointments,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.folder_shared_rounded,
                  label: 'Medical Records',
                  route: AppRoutes.medicalRecords,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.medication_rounded,
                  label: 'Prescriptions',
                  route: AppRoutes.prescriptions,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.star_rate_rounded,
                  label: 'Reviews',
                  route: AppRoutes.reviews,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.notifications_active_rounded,
                  label: 'Notifications',
                  route: AppRoutes.notifications,
                  currentRoute: currentRoute,
                ),
                _DrawerTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reports & Analytics',
                  route: AppRoutes.reports,
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: Text(
              'Sign Out',
              style: AppTypography.bodyMd(color: AppColors.error),
            ),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthCubit>().logout();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentRoute;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == route;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primary
            : (isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary),
      ),
      title: Text(
        label,
        style: AppTypography.bodyMd(
          color: isSelected
              ? AppColors.primary
              : (isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary),
          weight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }
}
