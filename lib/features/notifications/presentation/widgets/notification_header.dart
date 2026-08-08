import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationHeader extends StatelessWidget {
  final VoidCallback onMarkAllRead;
  final VoidCallback onSendNotification;

  const NotificationHeader({
    super.key,
    required this.onMarkAllRead,
    required this.onSendNotification,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Notification Center',
                    style: AppTypography.headingXl(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoaded && state.unreadCount > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusFull,
                            ),
                          ),
                          child: Text(
                            '${state.unreadCount} New',
                            style: AppTypography.labelSm(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Broadcast announcements, system alerts & target notifications to doctors, patients or clinic managers',
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            SecondaryButton(
              label: 'Mark All Read',
              leadingIcon: Icons.done_all_rounded,
              onPressed: onMarkAllRead,
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              label: 'Send Notification',
              leadingIcon: Icons.send_rounded,
              onPressed: onSendNotification,
            ),
          ],
        ),
      ],
    );
  }
}
