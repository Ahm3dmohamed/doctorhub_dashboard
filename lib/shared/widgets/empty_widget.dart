import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'primary_button.dart';

/// Reusable empty state widget with illustration placeholder
class EmptyWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
  });

  const EmptyWidget.noData({
    super.key,
    this.title = 'No Data Found',
    this.message = 'There is nothing to display here yet.',
    this.icon = Icons.grid_view_rounded,
    this.actionLabel,
    this.onAction,
  });

  const EmptyWidget.noResults({
    super.key,
    this.title = 'No Results',
    this.message = 'Try adjusting your search or filters.',
    this.icon = Icons.search_off_rounded,
    this.actionLabel,
    this.onAction,
  });

  const EmptyWidget.noPatients({
    super.key,
    this.title = 'No Patients Yet',
    this.message = 'Your patient list will appear here once added.',
    this.icon = Icons.people_outline_rounded,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container with gradient border
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radius2xl),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Icon(
                icon,
                size: 40,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.neutral400,
              ),
            ),

            const SizedBox(height: AppConstants.space5),

            Text(
              title,
              style: AppTypography.headingMd(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.space2),

            Text(
              message,
              style: AppTypography.bodyMd(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            if (onAction != null) ...[
              const SizedBox(height: AppConstants.space6),
              PrimaryButton(
                label: actionLabel ?? 'Get Started',
                onPressed: onAction,
                width: 180,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
