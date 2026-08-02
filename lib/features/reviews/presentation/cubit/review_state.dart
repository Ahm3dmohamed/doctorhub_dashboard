import 'package:equatable/equatable.dart';
import '../../domain/entities/review_entity.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

final class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

final class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

final class ReviewLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  final ReviewTargetType? selectedTargetType;
  final String? searchQuery;

  const ReviewLoaded({
    required this.reviews,
    this.selectedTargetType,
    this.searchQuery,
  });

  ReviewLoaded copyWith({
    List<ReviewEntity>? reviews,
    ReviewTargetType? selectedTargetType,
    String? searchQuery,
  }) {
    return ReviewLoaded(
      reviews: reviews ?? this.reviews,
      selectedTargetType: selectedTargetType ?? this.selectedTargetType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [reviews, selectedTargetType, searchQuery];
}

final class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
