import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<NotificationModel> createNotification(NotificationEntity notification);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'NOTIF-01',
      title: 'Scheduled System Maintenance',
      body: 'DoctorHub platform maintenance is scheduled for Sunday at 02:00 AM UTC. Downtime estimated ~15 mins.',
      type: NotificationType.warning,
      targetAudience: NotificationAudience.all,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: 'NOTIF-02',
      title: 'New Clinic Onboarded',
      body: 'Central Vascular Institute in Chicago has successfully completed verification and joined DoctorHub.',
      type: NotificationType.success,
      targetAudience: NotificationAudience.clinicManagers,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
    ),
    NotificationModel(
      id: 'NOTIF-03',
      title: 'Updated Prescription Regulations',
      body: 'Please review the updated FDA digital prescription guidelines in your dashboard documentation.',
      type: NotificationType.info,
      targetAudience: NotificationAudience.doctors,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: 'NOTIF-04',
      title: 'Security Alert',
      body: 'Multiple unsuccessful login attempts detected from IP 192.168.1.104. Account locked for 30 minutes.',
      type: NotificationType.alert,
      targetAudience: NotificationAudience.all,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(AppConstants.mockApiDelay);
    return List.from(_notifications);
  }

  @override
  Future<NotificationModel> createNotification(NotificationEntity notification) async {
    await Future.delayed(AppConstants.mockApiDelay);
    final model = NotificationModel.fromEntity(notification);
    _notifications.insert(0, model);
    return model;
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(AppConstants.mockApiDelay);
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final old = _notifications[idx];
      _notifications[idx] = NotificationModel(
        id: old.id,
        title: old.title,
        body: old.body,
        type: old.type,
        targetAudience: old.targetAudience,
        createdAt: old.createdAt,
        isRead: true,
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(AppConstants.mockApiDelay);
    for (int i = 0; i < _notifications.length; i++) {
      final old = _notifications[i];
      _notifications[i] = NotificationModel(
        id: old.id,
        title: old.title,
        body: old.body,
        type: old.type,
        targetAudience: old.targetAudience,
        createdAt: old.createdAt,
        isRead: true,
      );
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(AppConstants.mockApiDelay);
    _notifications.removeWhere((n) => n.id == id);
  }
}
