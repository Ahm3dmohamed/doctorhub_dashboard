import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../pages/widgets/state_card.dart';

/// Reviews page header with title, subtitle, and KPI stat cards.
class ReviewHeader extends StatelessWidget {
  const ReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ratings & Reviews Management',
          style: AppTypography.headingXl(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Monitor patient ratings, reply to clinic and doctor feedback, and manage customer sentiment',
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
                label: 'Average Rating',
                value: '4.85 / 5.0',
                icon: Icons.star_rounded,
                color: AppColors.warning,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StateCard(
                label: 'Total Reviews',
                value: '1,248',
                icon: Icons.rate_review_rounded,
                color: AppColors.primary,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StateCard(
                label: 'Response Rate',
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
