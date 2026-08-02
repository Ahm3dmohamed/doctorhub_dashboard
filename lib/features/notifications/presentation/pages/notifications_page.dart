import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBreadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                const BreadcrumbItem(label: 'Notification Center'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                            if (state is NotificationLoaded &&
                                state.unreadCount > 0) {
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
                Row(
                  children: [
                    SecondaryButton(
                      label: 'Mark All Read',
                      leadingIcon: Icons.done_all_rounded,
                      onPressed: () =>
                          context.read<NotificationCubit>().markAllAsRead(),
                    ),
                    const SizedBox(width: 12),
                    PrimaryButton(
                      label: 'Send Notification',
                      leadingIcon: Icons.send_rounded,
                      onPressed: () =>
                          _showCreateNotificationDialog(context, isDark),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space6),

            // Content List
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const LoadingWidget(
                    message: 'Loading Notifications...',
                  );
                }
                if (state is NotificationError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<NotificationCubit>().loadNotifications(),
                  );
                }
                if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.space10),
                        child: Text(
                          'No notifications found.',
                          style: AppTypography.headingMd(),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: state.notifications.map((notif) {
                      return _buildNotificationCard(context, notif, isDark);
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationEntity notif,
    bool isDark,
  ) {
    Color typeColor;
    IconData typeIcon;

    switch (notif.type) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.space3),
      decoration: BoxDecoration(
        color: notif.isRead
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
      // Using standard padding container layout
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
                        notif.title,
                        style: AppTypography.headingSm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                      ),
                      child: Text(
                        'Target: ${notif.targetAudience.displayName}',
                        style: AppTypography.labelSm(color: typeColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(notif.body, style: AppTypography.bodyMd()),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      DateFormat(
                        'MMM dd, yyyy • hh:mm a',
                      ).format(notif.createdAt),
                      style: AppTypography.bodySm(color: AppColors.neutral400),
                    ),
                    const Spacer(),
                    if (!notif.isRead)
                      TextButton(
                        onPressed: () => context
                            .read<NotificationCubit>()
                            .markAsRead(notif.id),
                        child: const Text('Mark as Read'),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                      onPressed: () => context
                          .read<NotificationCubit>()
                          .deleteNotification(notif.id),
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

  void _showCreateNotificationDialog(BuildContext context, bool isDark) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    NotificationType selectedType = NotificationType.info;
    NotificationAudience selectedAudience = NotificationAudience.all;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AppModalDialog(
            title: 'Send Target Notification',
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: titleCtrl,
                    label: 'Notification Title',
                    hint: 'e.g. System Maintenance Notice',
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: bodyCtrl,
                    label: 'Message Body',
                    hint: 'Type the notification content...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),

                  Text('Notification Type:', style: AppTypography.labelMd()),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: NotificationType.values.map((t) {
                      final isSelected = selectedType == t;
                      return ChoiceChip(
                        label: Text(t.displayName),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedType = t);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  Text('Target Audience:', style: AppTypography.labelMd()),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: NotificationAudience.values.map((aud) {
                      final isSelected = selectedAudience == aud;
                      return ChoiceChip(
                        label: Text(aud.displayName),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedAudience = aud);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  PrimaryButton(
                    label: 'Broadcast Notification',
                    leadingIcon: Icons.send_rounded,
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty &&
                          bodyCtrl.text.isNotEmpty) {
                        final notif = NotificationEntity(
                          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          title: titleCtrl.text,
                          body: bodyCtrl.text,
                          type: selectedType,
                          targetAudience: selectedAudience,
                          createdAt: DateTime.now(),
                          isRead: false,
                        );
                        context.read<NotificationCubit>().createNotification(
                          notif,
                        );
                        Navigator.of(dialogCtx).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
