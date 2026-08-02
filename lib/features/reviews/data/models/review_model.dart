import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.targetId,
    required super.targetName,
    required super.targetType,
    required super.authorName,
    required super.authorAvatar,
    required super.rating,
    required super.comment,
    super.reply,
    required super.date,
  });

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      targetId: entity.targetId,
      targetName: entity.targetName,
      targetType: entity.targetType,
      authorName: entity.authorName,
      authorAvatar: entity.authorAvatar,
      rating: entity.rating,
      comment: entity.comment,
      reply: entity.reply,
      date: entity.date,
    );
  }
}
