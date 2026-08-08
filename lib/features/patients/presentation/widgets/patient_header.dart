import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';

class PatientHeader extends StatelessWidget {
  final VoidCallback onAddPatient;

  const PatientHeader({
    super.key,
    required this.onAddPatient,
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
                'Patient Directory',
                style: AppTypography.headingXl(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage patient medical records, allergies, and emergency contacts',
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
          label: 'Add Patient',
          leadingIcon: Icons.person_add_rounded,
          onPressed: onAddPatient,
        ),
      ],
    );
  }
}
