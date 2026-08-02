import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.targetAudience,
    required super.createdAt,
    super.isRead,
  });

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      targetAudience: entity.targetAudience,
      createdAt: entity.createdAt,
      isRead: entity.isRead,
    );
  }
}
