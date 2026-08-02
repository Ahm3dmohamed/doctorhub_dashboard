import 'package:equatable/equatable.dart';

enum NotificationType {
  info,
  warning,
  success,
  alert;

  String get displayName => switch (this) {
        NotificationType.info => 'Info',
        NotificationType.warning => 'Warning',
        NotificationType.success => 'Success',
        NotificationType.alert => 'Alert',
      };
}

enum NotificationAudience {
  all,
  doctors,
  patients,
  clinicManagers;

  String get displayName => switch (this) {
        NotificationAudience.all => 'All Users',
        NotificationAudience.doctors => 'Doctors',
        NotificationAudience.patients => 'Patients',
        NotificationAudience.clinicManagers => 'Clinic Managers',
      };
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationAudience targetAudience;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetAudience,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, title, body, type, targetAudience, isRead];
}
