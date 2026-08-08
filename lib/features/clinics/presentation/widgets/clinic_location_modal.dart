import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/clinic_entity.dart';

class ClinicLocationModal extends StatelessWidget {
  final ClinicEntity clinic;

  const ClinicLocationModal({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppModalDialog(
      title: 'Location — ${clinic.name}',
      subtitle: '${clinic.location.address}, ${clinic.location.city}',
      confirmLabel: 'Close',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google Maps View',
                    style: AppTypography.headingSm(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Lat: ${clinic.location.latitude}, Long: ${clinic.location.longitude}',
                    style: AppTypography.labelSm(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Accepted Insurance Plans:',
            style: AppTypography.headingSm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: clinic.acceptedInsurance
                .map(
                  (ins) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusFull,
                      ),
                    ),
                    child: Text(
                      ins,
                      style: AppTypography.labelSm(
                        color: AppColors.successDark,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
