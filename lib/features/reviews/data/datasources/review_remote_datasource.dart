import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/review_entity.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviews({
    String? query,
    ReviewTargetType? targetType,
  });
  Future<void> replyToReview(String reviewId, String replyText);
  Future<void> deleteReview(String reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: 'REV-01',
      targetId: 'DOC-001',
      targetName: 'Dr. Alexander Wright',
      targetType: ReviewTargetType.doctor,
      authorName: 'Jessica Taylor',
      authorAvatar: 'JT',
      rating: 5.0,
      comment: 'Dr. Wright is extremely attentive and thorough. Explained my cardiovascular diagnosis in clear terms.',
      reply: 'Thank you Jessica for the kind feedback! Wish you good health.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReviewModel(
      id: 'REV-02',
      targetId: 'DOC-002',
      targetName: 'Dr. Elena Rostova',
      targetType: ReviewTargetType.doctor,
      authorName: 'David Miller',
      authorAvatar: 'DM',
      rating: 4.8,
      comment: 'Great neurological consultation. Minimal wait time and very professional clinic staff.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReviewModel(
      id: 'REV-03',
      targetId: 'CLN-001',
      targetName: 'Central Heart & Vascular Center',
      targetType: ReviewTargetType.clinic,
      authorName: 'Anthony Davis',
      authorAvatar: 'AD',
      rating: 4.9,
      comment: 'State-of-the-art facility! Very clean environment, friendly receptionists and seamless check-in.',
      reply: 'We appreciate your glowing review Anthony! Glad you had a smooth experience.',
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ReviewModel(
      id: 'REV-04',
      targetId: 'CLN-002',
      targetName: 'NeuroCare Institute',
      targetType: ReviewTargetType.clinic,
      authorName: 'Emily Clark',
      authorAvatar: 'EC',
      rating: 4.2,
      comment: 'Doctors are excellent, though parking can be a bit crowded during morning peak hours.',
      date: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  @override
  Future<List<ReviewModel>> getReviews({
    String? query,
    ReviewTargetType? targetType,
  }) async {
    await Future.delayed(AppConstants.mockApiDelay);
    return _reviews.where((r) {
      if (targetType != null && r.targetType != targetType) return false;
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchAuthor = r.authorName.toLowerCase().contains(q);
        final matchTarget = r.targetName.toLowerCase().contains(q);
        final matchComment = r.comment.toLowerCase().contains(q);
        return matchAuthor || matchTarget || matchComment;
      }
      return true;
    }).toList();
  }

  @override
  Future<void> replyToReview(String reviewId, String replyText) async {
    await Future.delayed(AppConstants.mockApiDelay);
    final idx = _reviews.indexWhere((r) => r.id == reviewId);
    if (idx != -1) {
      final old = _reviews[idx];
      _reviews[idx] = ReviewModel(
        id: old.id,
        targetId: old.targetId,
        targetName: old.targetName,
        targetType: old.targetType,
        authorName: old.authorName,
        authorAvatar: old.authorAvatar,
        rating: old.rating,
        comment: old.comment,
        reply: replyText,
        date: old.date,
      );
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await Future.delayed(AppConstants.mockApiDelay);
    _reviews.removeWhere((r) => r.id == reviewId);
  }
}
