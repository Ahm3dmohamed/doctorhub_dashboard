import 'package:doctorhub_dashboard/app/router/app_router.dart';
import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/activity_data.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class DashboardRecentActivityCard extends StatelessWidget {
  const DashboardRecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final activities = [
      ActivityData(
        icon: Icons.person_add_rounded,
        title: l10n.actNewPatient,
        subtitle: 'Emma Thompson',
        time: l10n.actTimeMinAgo(2),
        color: AppColors.primary,
        route: AppRoutes.patients,
      ),
      ActivityData(
        icon: Icons.check_circle_rounded,
        title: l10n.actAptCompleted,
        subtitle: 'Dr. Johnson — Room 4',
        time: l10n.actTimeMinAgo(18),
        color: AppColors.success,
        route: AppRoutes.appointments,
      ),
      ActivityData(
        icon: Icons.schedule_rounded,
        title: l10n.actAptRescheduled,
        subtitle: 'Michael Chen → 3:00 PM',
        time: l10n.actTimeHrAgo(1),
        color: AppColors.warning,
        route: AppRoutes.appointments,
      ),
      ActivityData(
        icon: Icons.medical_services_rounded,
        title: l10n.actLabUploaded,
        subtitle: 'Sarah Williams',
        time: l10n.actTimeHrsAgo(2),
        color: AppColors.info,
        route: AppRoutes.medicalRecords,
      ),
      ActivityData(
        icon: Icons.notifications_rounded,
        title: l10n.actSystemAlert,
        subtitle: 'Scheduled maintenance tonight',
        time: l10n.actTimeHrsAgo(3),
        color: AppColors.accent,
        route: AppRoutes.notifications,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dashRecentActivity,
                style: AppTypography.headingSm(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.notifications),
                child: Text(
                  l10n.commonViewAll,
                  style: AppTypography.bodySm(
                    color: AppColors.primary,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space3),
          ...activities.asMap().entries.map(
            (e) => ActivityItem(
              data: e.value,
              isLast: e.key == activities.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}
