import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

Widget buildFooter() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: Divider(color: AppColors.darkBorder, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space3,
            ),
            child: Text(
              'Secure login',
              style: AppTypography.labelSm(color: AppColors.darkTextMuted),
            ),
          ),
          Expanded(child: Divider(color: AppColors.darkBorder, thickness: 1)),
        ],
      ),
      const SizedBox(height: AppConstants.space4),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_rounded, size: 12, color: AppColors.darkTextMuted),
          const SizedBox(width: 6),
          Text(
            'Protected by DoctorHub Security',
            style: AppTypography.labelSm(color: AppColors.darkTextMuted),
          ),
        ],
      ),
    ],
  );
}
