import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/providers/reviews/reviews_state.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:state_notifier/state_notifier.dart';
import 'dart:io';

import '../../models/custom_error.dart';
import '../../models/review_model.dart';
import '../../repositories/review_repository.dart';

class ReviewProvider extends StateNotifier<ReviewState> with LocatorMixin {
  ReviewProvider() : super(ReviewState.initial());

  Future<void> getMyReviews() async {
    state = state.copyWith(reviewStatus: ReviewStatus.loading);
    List<Review> myReviewList = [];
    String uid = read<ProfileState>().user.id;
    try {
      List reviewsList =
          await read<RestaurantRepository>().getUsersReviews(userId: uid);
      reviewsList = reviewsList.toList();
      for (Map _review in reviewsList) {
        myReviewList.add(Review.fromDoc(_review));
      }
      state = state.copyWith(
          reviewStatus: ReviewStatus.loaded, reviewList: myReviewList);
    } on CustomError catch (e) {
      state = state.copyWith(reviewStatus: ReviewStatus.error);
      rethrow;
    }
  }

  Future<void> reviewComplete(
      {required String userId,
      required String userName,
      required String resId,
      required int score,
      required String resName,
      File? imgFile,
      required int icon,
      required DateTime date,
      int? reviewId,
      String? imgUrl,
      required int category}) async {
    state = state.copyWith(reviewStatus: ReviewStatus.loading);
    List<Review> myReviewList = state.reviewList;

    try {
      Map newReview = await read<ReviewRepository>().reviewComplete(
        userId: userId,
        userName: userName,
        resId: resId,
        score: score,
        imgFile: imgFile,
        icon: icon,
        date: date,
        reviewId: reviewId,
        imgUrl: imgUrl,
        category: category,
        resName: resName,
      );

      if (reviewId != null) {
        int targetIndex =
            myReviewList.indexWhere((element) => element.reviewId == reviewId);
        if (targetIndex == -1) {
          throw CustomError(message: "수정 중 오류가 발생했습니다", code: "알림");
        } else {
          newReview["category"] = category;
          myReviewList.removeAt(targetIndex);
          myReviewList.insert(targetIndex, Review.fromDoc(newReview));
          state = state.copyWith(
              reviewStatus: ReviewStatus.loaded, reviewList: myReviewList);
        }
      } else {
        myReviewList.insert(0, Review.fromDoc(newReview));
        state = state.copyWith(
            reviewStatus: ReviewStatus.loaded, reviewList: myReviewList);
      }
    } on CustomError catch (e) {
      state = state.copyWith(reviewStatus: ReviewStatus.error);
      rethrow;
    }
  }

  Future<void> reviewDelete(
      {required String resId, required String reviewId}) async {
    state = state.copyWith(reviewStatus: ReviewStatus.loading);
    List<Review> myReviewList = state.reviewList;
    try {
      await read<ReviewRepository>()
          .deleteReview(resId: resId, reviewId: reviewId);
      myReviewList
          .removeWhere((element) => element.reviewId.toString() == reviewId);
      state = state.copyWith(
          reviewStatus: ReviewStatus.loaded, reviewList: myReviewList);
    } on CustomError catch (e) {
      state = state.copyWith(reviewStatus: ReviewStatus.error);
      rethrow;
    }
  }

  Future<void> reviewLike(
      {required String targetId,
      required int reviewId,
      required String resName,
      required bool isAdd}) async {
    state = state.copyWith(reviewStatus: ReviewStatus.loading);
    String userId = read<ProfileState>().user.id;
    int userIcon = read<ProfileState>().user.icon;
    String userName = read<ProfileState>().user.name;

    try {
      await read<RestaurantRepository>().reviewLike(
          userId: userId,
          userIcon: userIcon,
          userName: userName,
          targetId: targetId,
          reviewId: reviewId,
          resName: resName,
          isAdd: isAdd);
      if (userId == targetId) {
        List<Review> myReviewList = state.reviewList;
        myReviewList.forEach((element) {
          if (element.reviewId == reviewId) {
            List _likes = element.likes;
            if (isAdd) {
              _likes.add(userId);
            } else {
              _likes.remove(userId);
            }
            element.likes = _likes;
          }
        });
        state = state.copyWith(
            reviewList: myReviewList, reviewStatus: ReviewStatus.loaded);
      }
    } on CustomError catch (e) {
      state = state.copyWith(reviewStatus: ReviewStatus.error);
      rethrow;
    }
  }
}
