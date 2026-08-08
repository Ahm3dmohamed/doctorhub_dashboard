import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      AppointmentStatus.upcoming => (
        AppColors.primary.withValues(alpha: 0.1),
        AppColors.primary,
      ),
      AppointmentStatus.completed => (
        AppColors.successLight,
        AppColors.successDark,
      ),
      AppointmentStatus.cancelled => (
        AppColors.errorLight,
        AppColors.errorDark,
      ),
      AppointmentStatus.pending => (
        AppColors.warning.withValues(alpha: 0.1),
        AppColors.warning,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.labelSm(color: fg),
      ),
    );
  }
}
