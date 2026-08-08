import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/constants/app_constants.dart';

Widget buildHeader(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
          Text(l10n.appName, style: AppTypography.brand(color: Colors.white)),
        ],
      ),
      const SizedBox(height: AppConstants.space4),
      Text(
        l10n.authWelcomeBack,
        style: AppTypography.displaySm(color: Colors.white),
      ),
      const SizedBox(height: AppConstants.space2),
      Text(
        l10n.authLoginSubtitle,
        style: AppTypography.bodyLg(color: AppColors.darkTextSecondary),
      ),
    ],
  );
}
