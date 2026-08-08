import 'package:doctorhub_dashboard/app/router/app_router.dart';
import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/quik_action_button.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/quik_action_data.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DashboardQuickActionsCard extends StatelessWidget {
  final UserRole role;

  const DashboardQuickActionsCard({super.key, required this.role});

  List<QuickActionData> _buildActions(UserRole role, AppLocalizations l10n) => [
    QuickActionData(
      icon: Icons.person_add_rounded,
      label: l10n.dashAddPatient,
      color: AppColors.primary,
      route: AppRoutes.patients,
    ),
    QuickActionData(
      icon: Icons.event_available_rounded,
      label: l10n.dashBookAppointment,
      color: AppColors.success,
      route: AppRoutes.appointments,
    ),
    if (role == UserRole.doctor || role == UserRole.superAdmin)
      QuickActionData(
        icon: Icons.note_add_rounded,
        label: l10n.dashNewPrescription,
        color: AppColors.info,
        route: AppRoutes.prescriptions,
      ),
    if (role == UserRole.superAdmin || role == UserRole.clinicManager)
      QuickActionData(
        icon: Icons.person_search_rounded,
        label: l10n.navDoctors,
        color: AppColors.warning,
        route: AppRoutes.doctors,
      ),
    QuickActionData(
      icon: Icons.download_rounded,
      label: l10n.dashViewAnalytics,
      color: AppColors.accent,
      route: AppRoutes.reports,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final actions = _buildActions(role, l10n);

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
          Text(
            l10n.dashQuickActions,
            style: AppTypography.headingSm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.space4),
          ...actions.map((a) => QuickActionButton(data: a)),
        ],
      ),
    );
  }
}
