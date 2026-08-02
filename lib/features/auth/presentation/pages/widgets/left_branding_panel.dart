import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class LeftBrandingPanel extends StatelessWidget {
  const LeftBrandingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space4,
            vertical: AppConstants.space2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.space2),
              Text(
                'Healthcare Platform',
                style: AppTypography.labelSm(color: AppColors.primaryLight),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.space4),

        RichText(
          text: TextSpan(
            style: AppTypography.displayMd(color: Colors.white),
            children: [
              const TextSpan(text: 'The modern way to\nmanage '),
              TextSpan(
                text: 'healthcare',
                style: AppTypography.displayMd().copyWith(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.accentLight],
                    ).createShader(const Rect.fromLTWH(0, 0, 300, 60)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.space4),

        Text(
          'DoctorHub centralizes patient records, appointments,\nand analytics for doctors, clinics, and administrators.',
          style: AppTypography.bodyLg(color: AppColors.darkTextSecondary),
        ),

        const SizedBox(height: AppConstants.space8),

        // Feature list
        ...[
          (Icons.analytics_rounded, 'Real-time analytics & insights'),
          (Icons.people_rounded, 'Patient management simplified'),
          (Icons.calendar_month_rounded, 'Smart appointment scheduling'),
          (Icons.security_rounded, 'HIPAA-compliant & secure'),
        ].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space4),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Icon(item.$1, size: 18, color: Colors.white),
                ),
                const SizedBox(width: AppConstants.space3),
                Text(item.$2, style: AppTypography.bodyMd(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
