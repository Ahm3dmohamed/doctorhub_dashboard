import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

Widget buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Logo
      Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: AppConstants.space3),
          Text('DoctorHub', style: AppTypography.brand(color: Colors.white)),
        ],
      ),

      const SizedBox(height: AppConstants.space4),

      Text('Welcome back', style: AppTypography.displaySm(color: Colors.white)),

      const SizedBox(height: AppConstants.space2),

      Text(
        'Sign in to your healthcare dashboard',
        style: AppTypography.bodyLg(color: AppColors.darkTextSecondary),
      ),
    ],
  );
}
