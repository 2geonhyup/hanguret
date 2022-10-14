import 'dart:convert';

import 'package:gallery_saver/files.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/screens/main_screen/main_output.dart';
import 'package:hangeureut/screens/profile_screen/profile_page_output.dart';
import 'package:hangeureut/screens/restaurant_detail_screen/restaurant_detail_output.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hangeureut/screens/review_screen/review_output.dart';
import 'package:http/http.dart' as http;

String _url = 'ec2-3-35-52-247.ap-northeast-2.compute.amazonaws.com:3001';

class RestaurantRepository {
  Future<List<Map>?> getRestaurants(
      {required int mainFilterNum, required bool sortType}) async {
    // 사용자 위치 찾기
    // input 보내기
    // output 받기

    try {
      Uri _uri = Uri.http(_url, '/restaurants');

      var response = await http.get(_uri);

      print(response.body);
    } catch (e) {
      print(e);
    }

    //await Future.delayed(Duration(milliseconds: 1000));
    switch (mainFilterNum) {
      case 1:
        return mainOutputList1;
      case 2:
        return mainOutputList2;
      default:
        return mainOutputList0;
    }
  }

  Future<Map> getRestaurantsDetail({
    required String resId,
  }) async {
    //input 보내기 -> 백엔드 연동시 추가(userId, location, resId보냄)

    //output 받기 -> 백엔드 연동시 수정 (현재는 라플로레종 아니면 리피토리아만 뜨게 둠)
    if (resId == "4")
      return resDetailOutputMy4;
    else
      return resDetailOutputMy3;
  }

  Future<List> getRestaurantsReviews({
    required String resId,
  }) async {
    //input 보내기 -> 백엔드 연동시 추가

    //output 받기 -> 백엔드 연동시 수정
    return resDetailOutputAll3;
  }

  Future<void> reviewLike(
      {required String userId,
      required int userIcon,
      required String userName,
      required String targetId,
      required String reviewId,
      required String resName,
      required bool isAdd}) async {
    //input 보내기 (reviewId, 좋아요+-)

    if (isAdd) {
      await usersRef
          .doc(targetId)
          .collection('news')
          .doc("$userId$reviewId")
          .set({
        "type": 1,
        "date": DateTime.now(),
        "content": {
          "id": userId,
          "name": userName,
          "icon": userIcon,
          "resName": resName
        }
      });
    }
  }

  Future<List> getUsersReviews({required String userId}) async {
    //백엔드 연동 한 후, userId에 따라 다른 리뷰를 보내줘야 함
    return myReviewList;
  }

  Future<void> saveRemoveRes(
      {required String userId,
      required String resId,
      required String imgUrl,
      required bool isSave}) async {
    try {
      if (isSave) {
        await usersRef
            .doc(userId)
            .collection("saved")
            .doc(resId)
            .set({"resId": resId, "imgUrl": imgUrl});
      } else {
        await usersRef.doc(userId).collection("saved").doc(resId).delete();
      }
    } catch (e) {
      throw CustomError(code: "통신 오류", message: "제대로 저장되지 않았습니다!");
    }
  }

  Future<void> sendNewRes({required content, required userId}) async {
    await FirebaseFirestore.instance
        .collection("newRestaurants")
        .doc()
        .set({"content": content, "userId": userId});
  }

  Future<Map<String, List>?> getResForReview() async {
    List popularResList = [];
    List nearResList = [];

    //백엔드 연결시 수정
    popularResList = popularRes;
    nearResList = nearRes;
    return {
      "popular": popularResList,
      "near": nearResList,
    };
  }

  Future<List<Map>?> getResByPopularity() async {
    return mainOutputList0;
  }
}
