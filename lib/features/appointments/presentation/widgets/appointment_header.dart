import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/primary_button.dart';

class AppointmentHeader extends StatelessWidget {
  final bool isCalendarView;
  final VoidCallback onToggleView;
  final VoidCallback onBookAppointment;

  const AppointmentHeader({
    super.key,
    required this.isCalendarView,
    required this.onToggleView,
    required this.onBookAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.apptsTitle,
                style: AppTypography.headingXl(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.apptsSubtitle,
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            SecondaryButton(
              label: isCalendarView ? l10n.apptsTableTab : l10n.apptsCalendarTab,
              leadingIcon: isCalendarView
                  ? Icons.table_chart_rounded
                  : Icons.calendar_month_rounded,
              onPressed: onToggleView,
            ),
            const SizedBox(width: AppConstants.space3),
            PrimaryButton(
              label: l10n.apptsBook,
              leadingIcon: Icons.add_rounded,
              onPressed: onBookAppointment,
            ),
          ],
        ),
      ],
    );
  }
}
