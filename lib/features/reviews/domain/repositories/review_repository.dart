import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getReviews({
    String? query,
    ReviewTargetType? targetType,
  });

  Future<Either<Failure, void>> replyToReview(String reviewId, String replyText);
  Future<Either<Failure, void>> deleteReview(String reviewId);
}
