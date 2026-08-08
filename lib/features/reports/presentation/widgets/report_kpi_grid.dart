import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';

/// A single KPI metric card for the reports dashboard.
class ReportKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String growth;
  final IconData icon;
  final Color color;

  const ReportKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.growth,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  growth,
                  style: AppTypography.labelSm(
                    color: isDark ? Colors.white : AppColors.successDark,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.headingLg(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                label,
                style: AppTypography.bodySm(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Responsive grid of KPI cards.
class ReportKpiGrid extends StatelessWidget {
  final String monthlyRevenue;
  final String revenueGrowth;
  final String totalBookings;
  final String bookingsGrowth;
  final String newPatients;
  final String patientsGrowth;
  final String avgRating;

  const ReportKpiGrid({
    super.key,
    required this.monthlyRevenue,
    required this.revenueGrowth,
    required this.totalBookings,
    required this.bookingsGrowth,
    required this.newPatients,
    required this.patientsGrowth,
    required this.avgRating,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isDesktop ? 4 : 2,
          crossAxisSpacing: AppConstants.space4,
          mainAxisSpacing: AppConstants.space4,
          childAspectRatio: isDesktop ? 1.6 : 1.4,
          children: [
            ReportKpiCard(
              label: 'Monthly Revenue',
              value: monthlyRevenue,
              growth: revenueGrowth,
              icon: Icons.payments_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: 'Total Appointments',
              value: totalBookings,
              growth: bookingsGrowth,
              icon: Icons.calendar_month_rounded,
              color: AppColors.accent,
            ),
            ReportKpiCard(
              label: 'New Patients',
              value: newPatients,
              growth: patientsGrowth,
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: 'Avg Doctor Rating',
              value: avgRating,
              growth: '+0.2',
              icon: Icons.star_rounded,
              color: AppColors.warning,
            ),
          ],
        );
      },
    );
  }
}
