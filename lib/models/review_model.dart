import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  int reviewId;
  String date;
  String userId;
  String userName;
  String score;
  int category;
  int icon;
  String imgUrl;
  List likes;
  String resId;
  String resName;

  Review(
      {required this.reviewId,
      required this.date,
      required this.userId,
      required this.userName,
      required this.score,
      required this.category,
      required this.icon,
      required this.imgUrl,
      required this.likes,
      required this.resId,
      required this.resName});

  factory Review.fromDoc(Map review) {
    if (review["icon"] < 0 || review["icon"] > 5) {
      review["icon"] = -1;
    }
    return Review(
        reviewId: review["reviewId"],
        date: review["date"],
        userId: review["userId"],
        userName: review["userName"],
        score: review["score"],
        category: review["category"],
        icon: review["icon"],
        imgUrl: review["imgUrl"],
        likes: review["likes"],
        resId: review["resId"],
        resName: review["resName"] ?? "");
  }

  @override
  List<Object> get props {
    return [
      reviewId,
      date,
      userId,
      userName,
      score,
      category,
      icon,
      imgUrl,
      likes,
      resId,
      resName
    ];
  }

  @override
  bool get stringify => true;
}
