import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _repository;

  ReviewCubit(this._repository) : super(const ReviewInitial());

  Future<void> loadReviews({
    String? query,
    ReviewTargetType? targetType,
  }) async {
    emit(const ReviewLoading());
    final res = await _repository.getReviews(
      query: query,
      targetType: targetType,
    );
    res.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewLoaded(
        reviews: reviews,
        selectedTargetType: targetType,
        searchQuery: query,
      )),
    );
  }

  Future<void> replyToReview(String reviewId, String replyText) async {
    final res = await _repository.replyToReview(reviewId, replyText);
    res.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => loadReviews(),
    );
  }

  Future<void> deleteReview(String reviewId) async {
    final res = await _repository.deleteReview(reviewId);
    res.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => loadReviews(),
    );
  }
}
