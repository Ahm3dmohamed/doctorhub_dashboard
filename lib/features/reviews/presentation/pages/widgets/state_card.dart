import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class StateCard extends StatelessWidget {
  const StateCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppConstants.space3),
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
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
