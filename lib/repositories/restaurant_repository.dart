import 'dart:convert';

import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;

String _url = 'ec2-3-35-52-247.ap-northeast-2.compute.amazonaws.com:3001';

class RestaurantRepository {
  Future<List<Map>?> getRestaurants({required bool sortType}) async {
    // 사용자 위치 찾기
    // input 보내기
    // output 받기
    List<Map>? allRes;

    try {
      Uri _uri = Uri.http(_url, '/restaurants/popular');

      var response = await http.get(_uri);
      //print(response.body);
      allRes =
          (jsonDecode(response.body) as List).map((e) => e as Map).toList();
    } catch (e) {
      throw const CustomError(code: "알림", message: "식당 정보 받기 오류");
    }

    return allRes;
  }

  Future<Map> getRestaurantsDetail({
    required String resId,
  }) async {
    //input 보내기 -> 백엔드 연동시 추가(userId, location, resId 보냄)
    try {
      Uri _uri = Uri.http(_url, '/restaurants/id/$resId');

      var response = await http.get(_uri);

      Map body = jsonDecode(response.body) as Map;

      return body;
    } catch (e) {
      throw const CustomError(code: "알림", message: "식당 정보 받기 오류");
    }
  }

  Future<List> getRestaurantsReviews({
    required String resId,
  }) async {
    //input 보내기 -> 백엔드 연동시 추가(userId, location, resId 보냄
    try {
      Uri _uri = Uri.http(_url, '/reviews/restaurant/id/$resId');

      var response = await http.get(_uri);
      //print("reviewrepo${response.body}");
      List body = (jsonDecode(response.body) as List).map((e) {
        final eMap = e as Map;
        var date = eMap["date"];
        var val = DateTime.parse(date);
        eMap["date"] = "${val.year}년 ${val.month}월 ${val.day}일";
        return eMap;
      }).toList();
      //print("body$body");
      return body.reversed.toList();
    } catch (e) {
      throw CustomError(
          code: "알림", message: "리뷰 정보 받기 오류", plugin: e.toString());
    }
  }

  Future<void> reviewLike(
      {required String userId,
      required int userIcon,
      required String userName,
      required String targetId,
      required int reviewId,
      required String resName,
      required bool isAdd}) async {
    try {
      Uri _uri = Uri.http(_url, '/reviews/$reviewId/user/$userId');
      var response = await http.put(_uri);

      if (isAdd) {
        await usersRef
            .doc(targetId)
            .collection('news')
            .doc("$userId$reviewId")
            .set({
          "type": 2,
          "date": DateTime.now(),
          "content": {
            "id": userId,
            "name": userName,
            "icon": userIcon,
            "resName": resName
          }
        });
      }
    } catch (e) {
      throw const CustomError(code: "알림", message: "좋아요를 누르지 못함");
    }
  }

  Future<List> getUsersReviews({required String userId}) async {
    //백엔드 연동 한 후, userId에 따라 다른 리뷰를 보내줘야 함

    try {
      Uri _uri = Uri.http(_url, '/reviews/user/$userId');

      var response = await http.get(_uri);
      List body = (jsonDecode(response.body) as List).map((e) {
        final eMap = e as Map;
        var date = eMap["date"];
        var val = DateTime.parse(date);

        eMap["date"] = "${val.year}년 ${val.month}월 ${val.day}일";
        return eMap;
      }).toList();

      return body.toList();
    } catch (e) {
      throw CustomError(
          code: "알림", message: "리뷰 정보 받기 오류", plugin: e.toString());
    }
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
      throw CustomError(code: "알림", message: "제대로 저장되지 않았습니다!");
    }
  }

  Future<void> sendNewRes({required content, required userId}) async {
    await FirebaseFirestore.instance
        .collection("newRestaurants")
        .doc()
        .set({"content": content, "userId": userId});
  }

  Future<List?> getSearchedRestaurants(
      {required String searchTerm, int? length}) async {
    List searchedList = [];
    try {
      Uri _uri = Uri.http(_url, '/restaurants/search/$searchTerm');

      var response = await http.get(_uri);

      searchedList =
          (jsonDecode(response.body) as List).map((e) => e as Map).toList();

      if (length != null && searchedList.length > length) {
        return searchedList.sublist(0, length);
      }

      return searchedList;
    } catch (e) {
      throw CustomError(
          code: "알림", message: "식당 정보 받기 오류", plugin: e.toString());
    }
  }

  Future<int> getDistance(
      {required String address,
      required double userLat,
      required double userLong}) async {
    try {
      Uri _uri = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: '/maps/api/distancematrix/json',
        query:
            'units=metric&mode=transit&origins=$userLat,$userLong&destinations=$address&region=KR&key=AIzaSyA_0_VpLRcvV6qXc9kzap_fmwYK7chkdvc',
      );

      var response = await http.get(_uri);
      var body = jsonDecode(response.body) as Map;

      return body["rows"][0]["elements"][0]["distance"]["value"] ?? -1;
    } catch (e) {
      throw const CustomError(code: "알림", message: "식당 정보 받기 오류");
    }
  }
}
