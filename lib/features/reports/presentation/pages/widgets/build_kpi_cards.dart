import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/constants/app_constants.dart';

Widget buildKpiCard(
  String label,
  String value,
  String growth,
  IconData icon,
  Color color,
  bool isDark,
) {
  return Container(
    padding: const EdgeInsets.all(AppConstants.space4),
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      border: Border.all(
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
              child: Text(
                growth,
                style: AppTypography.labelSm(
                  color: isDark ? Colors.white : AppColors.successDark,
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.headingLg()),
            Text(
              label,
              style: AppTypography.bodySm(
                color: isDark ? Colors.white : AppColors.neutral400,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
