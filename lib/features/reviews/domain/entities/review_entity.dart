import 'package:equatable/equatable.dart';

enum ReviewTargetType {
  doctor,
  clinic;

  String get displayName => switch (this) {
        ReviewTargetType.doctor => 'Doctor Review',
        ReviewTargetType.clinic => 'Clinic Review',
      };
}

class ReviewEntity extends Equatable {
  final String id;
  final String targetId;
  final String targetName;
  final ReviewTargetType targetType;
  final String authorName;
  final String authorAvatar;
  final double rating;
  final String comment;
  final String? reply;
  final DateTime date;

  const ReviewEntity({
    required this.id,
    required this.targetId,
    required this.targetName,
    required this.targetType,
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.comment,
    this.reply,
    required this.date,
  });

  @override
  List<Object?> get props => [id, targetId, targetType, rating, comment, reply];
}
