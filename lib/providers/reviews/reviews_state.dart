import 'package:equatable/equatable.dart';

import '../../models/review_model.dart';

enum ReviewStatus {
  none,
  loading,
  loaded,
  error,
}

class ReviewState extends Equatable {
  final ReviewStatus reviewStatus;
  final List<Review> reviewList;
  ReviewState({
    required this.reviewStatus,
    required this.reviewList,
  });

  factory ReviewState.initial() {
    return ReviewState(
      reviewStatus: ReviewStatus.none,
      reviewList: [],
    );
  }

  @override
  List<Object> get props => [reviewStatus, reviewList];

  @override
  bool get stringify => true;

  ReviewState copyWith({
    ReviewStatus? reviewStatus,
    List<Review>? reviewList,
  }) {
    return ReviewState(
        reviewStatus: reviewStatus ?? this.reviewStatus,
        reviewList: reviewList ?? this.reviewList);
  }
}
