import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'primary_button.dart';

/// Reusable error state widget with icon, message, and optional retry action
class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.retryLabel,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  const AppErrorWidget.network({
    super.key,
    this.title = 'No Connection',
    this.message = 'Please check your internet connection and try again.',
    this.retryLabel = 'Try Again',
    this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  const AppErrorWidget.server({
    super.key,
    this.title = 'Server Error',
    this.message = 'Our servers are experiencing issues. Please try again later.',
    this.retryLabel = 'Retry',
    this.onRetry,
    this.icon = Icons.cloud_off_rounded,
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
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppConstants.radius2xl),
              ),
              child: Icon(
                icon,
                size: 36,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: AppConstants.space5),

            // Title
            Text(
              title,
              style: AppTypography.headingMd(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.space2),

            // Message
            Text(
              message,
              style: AppTypography.bodyMd(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.space6),
              PrimaryButton(
                label: retryLabel ?? 'Try Again',
                onPressed: onRetry,
                width: 160,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline error banner (shown inside forms)
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.animNormal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space4,
        vertical: AppConstants.space3,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.error,
          ),
          const SizedBox(width: AppConstants.space2),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySm(color: AppColors.errorDark),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.error,
              ),
            ),
        ],
      ),
    );
  }
}
