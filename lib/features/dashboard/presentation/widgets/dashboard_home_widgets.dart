import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/state_card_data.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/state_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_entity.dart';

class DashboardStatsGrid extends StatelessWidget {
  final UserRole role;

  const DashboardStatsGrid({super.key, required this.role});

  List<StatCardData> _buildStats(UserRole role, AppLocalizations l10n) => [
    StatCardData(
      label: l10n.dashTotalPatients,
      value: '1,248',
      change: '+12%',
      isPositive: true,
      icon: Icons.people_rounded,
      gradient: AppColors.primaryGradient,
      route: AppRoutes.patients,
    ),
    StatCardData(
      label: l10n.dashTodayAppointments,
      value: '24',
      change: '+3',
      isPositive: true,
      icon: Icons.calendar_today_rounded,
      gradient: AppColors.successGradient,
      route: AppRoutes.appointments,
    ),
    StatCardData(
      label: l10n.dashPendingReviews,
      value: '7',
      change: '-2',
      isPositive: true,
      icon: Icons.rate_review_rounded,
      gradient: AppColors.warningGradient,
      route: AppRoutes.reviews,
    ),
    if (role == UserRole.superAdmin || role == UserRole.clinicManager)
      StatCardData(
        label: l10n.dashActiveDoctors,
        value: '18',
        change: '+1',
        isPositive: true,
        icon: Icons.medical_services_rounded,
        gradient: AppColors.infoGradient,
        route: AppRoutes.doctors,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = _buildStats(role, l10n);
    final columns = _gridColumns(context).clamp(1, 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppConstants.space4,
        mainAxisSpacing: AppConstants.space4,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, i) => StatCardWidget(stat: stats[i]),
    );
  }

  int _gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 800) return 2;
    return 1;
  }
}
