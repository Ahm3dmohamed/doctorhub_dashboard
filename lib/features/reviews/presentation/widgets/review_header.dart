import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../pages/widgets/state_card.dart';

/// Reviews page header with title, subtitle, and KPI stat cards.
class ReviewHeader extends StatelessWidget {
  const ReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reviewsTitle,
          style: AppTypography.headingXl(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.reviewsSubtitle,
          style: AppTypography.bodyMd(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: StateCard(
                label: l10n.reviewsAvgRating,
                value: '4.85 / 5.0',
                icon: Icons.star_rounded,
                color: AppColors.warning,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StateCard(
                label: l10n.reviewsTotal,
                value: '1,248',
                icon: Icons.rate_review_rounded,
                color: AppColors.primary,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StateCard(
                label: l10n.reviewsResponseRate,
                value: '94.2%',
                icon: Icons.reply_all_rounded,
                color: AppColors.success,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
