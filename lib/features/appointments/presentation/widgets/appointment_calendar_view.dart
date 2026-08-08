import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/appointment_entity.dart';
import 'appointment_status_badge.dart';

class AppointmentCalendarView extends StatelessWidget {
  final List<AppointmentEntity> appointments;

  const AppointmentCalendarView({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.space6),
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
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: AppTypography.headingMd(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${appointments.length} Total Bookings',
                style: AppTypography.labelMd(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space6),
          ...appointments.map(
            (a) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('dd\nMMM').format(a.dateTime),
                        textAlign: TextAlign.center,
                        style: AppTypography.labelSm(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${a.patientName} — ${a.doctorName}',
                          style: AppTypography.bodyMd(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${a.reason} • ${DateFormat('hh:mm a').format(a.dateTime)}',
                          style: AppTypography.bodySm(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppointmentStatusBadge(status: a.status),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
