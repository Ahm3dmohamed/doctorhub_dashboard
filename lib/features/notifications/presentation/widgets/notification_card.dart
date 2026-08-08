import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    Color typeColor;
    IconData typeIcon;

    switch (notification.type) {
      case NotificationType.info:
        typeColor = AppColors.info;
        typeIcon = Icons.info_outline_rounded;
        break;
      case NotificationType.warning:
        typeColor = AppColors.warning;
        typeIcon = Icons.warning_amber_rounded;
        break;
      case NotificationType.success:
        typeColor = AppColors.success;
        typeIcon = Icons.check_circle_outline_rounded;
        break;
      case NotificationType.alert:
        typeColor = AppColors.error;
        typeIcon = Icons.gpp_maybe_rounded;
        break;
    }

    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.space3),
      decoration: BoxDecoration(
        color: notification.isRead
            ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
            : typeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border(
          left: BorderSide(color: typeColor, width: 4),
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(typeIcon, color: typeColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTypography.headingSm(color: primaryTextColor),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Text(
                        '${l10n.notifTarget}: ${notification.targetAudience.displayName}',
                        style: AppTypography.labelSm(color: typeColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.body,
                  style: AppTypography.bodyMd(color: primaryTextColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a')
                          .format(notification.createdAt),
                      style: AppTypography.bodySm(color: secondaryTextColor),
                    ),
                    const Spacer(),
                    if (!notification.isRead)
                      TextButton(
                        onPressed: onMarkAsRead,
                        child: Text(
                          l10n.commonViewAll,
                          style: AppTypography.bodySm(color: AppColors.primary),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                      onPressed: onDelete,
                      tooltip: l10n.commonDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
