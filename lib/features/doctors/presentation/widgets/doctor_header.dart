import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';

class DoctorHeader extends StatelessWidget {
  final VoidCallback onAddDoctor;

  const DoctorHeader({
    super.key,
    required this.onAddDoctor,
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
                'Doctors Management',
                style: AppTypography.headingXl(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage doctor profiles, specialties, and working hours',
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
        PrimaryButton(
          label: 'Add Doctor',
          leadingIcon: Icons.add_rounded,
          onPressed: onAddDoctor,
        ),
      ],
    );
  }
}
