import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../widgets/create_notification_dialog.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_header.dart';

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

  void _showCreateNotificationDialog() {
    showDialog(
      context: context,
      builder: (_) => CreateNotificationDialog(
        onSend: (notif) {
          context.read<NotificationCubit>().createNotification(notif);
        },
      ),
    );
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
            NotificationHeader(
              onMarkAllRead: () =>
                  context.read<NotificationCubit>().markAllAsRead(),
              onSendNotification: _showCreateNotificationDialog,
            ),
            const SizedBox(height: AppConstants.space6),
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
                    return const EmptyWidget(
                      title: 'No Notifications Found',
                      message: 'There are no active system notifications.',
                      icon: Icons.notifications_none_rounded,
                    );
                  }

                  return Column(
                    children: state.notifications.map((notif) {
                      return NotificationCard(
                        notification: notif,
                        onMarkAsRead: () {
                          context
                              .read<NotificationCubit>()
                              .markAsRead(notif.id);
                        },
                        onDelete: () {
                          context
                              .read<NotificationCubit>()
                              .deleteNotification(notif.id);
                        },
                      );
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
}
