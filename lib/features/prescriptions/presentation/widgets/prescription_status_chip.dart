import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/prescription_entity.dart';

class PrescriptionStatusChip extends StatelessWidget {
  final PrescriptionStatus status;

  const PrescriptionStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == PrescriptionStatus.active;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.successLight
            : AppColors.neutral200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.labelSm(
          color: isActive ? AppColors.successDark : AppColors.neutral700,
        ),
      ),
    );
  }
}
