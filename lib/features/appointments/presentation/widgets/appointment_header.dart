import 'package:flutter/material.dart';
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointments & Scheduling',
                style: AppTypography.headingXl(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage upcoming patient consultations, reschedule or approve bookings',
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
              label: isCalendarView ? 'Table View' : 'Calendar View',
              leadingIcon: isCalendarView
                  ? Icons.table_chart_rounded
                  : Icons.calendar_month_rounded,
              onPressed: onToggleView,
            ),
            const SizedBox(width: AppConstants.space3),
            PrimaryButton(
              label: 'Book Appointment',
              leadingIcon: Icons.add_rounded,
              onPressed: onBookAppointment,
            ),
          ],
        ),
      ],
    );
  }
}
