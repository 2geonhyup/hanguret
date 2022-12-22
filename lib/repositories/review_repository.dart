import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/custom_error.dart';

String _url = 'ec2-3-35-52-247.ap-northeast-2.compute.amazonaws.com:3001';

Future<String> getStorageDirectory() async {
  if (Platform.isAndroid) {
    return (await getExternalStorageDirectory())!
        .path; // OR return "/storage/emulated/0/Download";
  } else {
    return (await getApplicationDocumentsDirectory()).path;
  }
}

class ReviewRepository {
  final FirebaseFirestore firebaseFirestore;
  ReviewRepository({required this.firebaseFirestore});

  Future<Map> reviewComplete(
      {required String userId,
      required String userName,
      required String resId,
      required int score,
      File? imgFile,
      required int icon,
      required DateTime date,
      int? reviewId,
      String? imgUrl,
      required int category,
      required String resName}) async {
    Map responseMap = {};
    if (imgFile != null) {
      //사진 등록
      try {
        FormData _formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(imgFile.path,
              filename: "review_image"),
        });

        var options = BaseOptions(
          baseUrl: "http://$_url",
          connectTimeout: 5000,
          receiveTimeout: 3000,
        );

        Dio dio = Dio(options);
        var response = await dio.post("/uploads", data: _formData);
        imgUrl = response.data["data"][0]["url"];
      } catch (e) {
        throw CustomError(
          code: "알림",
          message: "리뷰를 기록하는 과정에서 오류가 발생했습니다",
        );
      }
    }

    if (imgUrl == null) {
      throw const CustomError(code: "알림", message: "리뷰를 기록하는 과정에서 오류가 발생했습니다");
    }

    if (reviewId == null) {
      //리뷰 등록
      try {
        Uri _uri = Uri.http(_url, '/reviews');
        var response = await http.post(_uri, body: {
          "userName": userName,
          "userId": userId,
          "resId": resId,
          "score": "$score",
          "icon": "$icon",
          "imgUrl": imgUrl,
          "category": category.toString(),
          "resName": resName,
        });
        responseMap = jsonDecode(response.body) as Map;

        responseMap["icon"] = int.parse(responseMap["icon"]);
        var val = DateTime.parse(responseMap["date"]);
        responseMap["date"] = "${val.year}년 ${val.month}월 ${val.day}일";
        reviewId = responseMap["reviewId"];
      } catch (e) {
        throw CustomError(
            code: "알림",
            message: "리뷰를 기록하는 과정에서 오류가 발생했습니다",
            plugin: e.toString());
      }
    } else {
      //리뷰 수정
      try {
        {
          Uri _uri = Uri.http(_url, '/reviews/$reviewId');
          var response = await http.put(_uri,
              body: {"score": "$score", "icon": "$icon", "imgUrl": imgUrl});
          responseMap = jsonDecode(response.body) as Map;
          responseMap["icon"] = int.parse(responseMap["icon"]);
          var val = DateTime.parse(responseMap["date"]);
          responseMap["date"] = "${val.year}년 ${val.month}월 ${val.day}일";
          reviewId = responseMap["reviewId"];
          return responseMap;
        }
      } catch (e) {
        throw CustomError(code: "알림", message: "리뷰를 수정하는 과정에서 오류가 발생했습니다");
      }
    }

    // 새로 등록의 경우에만 아래 코드 실행
    if (reviewId == null) {
      throw const CustomError(code: "알림", message: "리뷰를 기록하는 과정에서 오류가 발생했습니다");
    }
    //리뷰 카운트 업데이트
    try {
      Uri _uri = Uri.http(_url, '/restaurants/count/$resId');

      var response = await http.put(_uri);
    } catch (e) {
      throw const CustomError(code: "알림", message: "리뷰를 기록하는 과정에서 오류가 발생했습니다");
    }

    return responseMap;
  }

  Future<void> deleteReview(
      {required String resId, required String reviewId}) async {
    //리뷰 카운트 다운
    try {
      Uri _uri = Uri.http(_url, 'restaurants/desc/$resId');
      var response = await http.put(_uri);
      Map body = jsonDecode(response.body) as Map;
      if (body["success"] == false) {
        throw CustomError(code: "알림", message: "리뷰 삭제 중 오류");
      }
    } catch (e) {
      throw CustomError(code: "알림", message: "리뷰 삭제 중 오류");
    }

    //리뷰 제거
    try {
      Uri _uri = Uri.http(_url, 'reviews/$reviewId');
      var response = await http.delete(_uri);
    } catch (e) {
      throw CustomError(
          code: "알림", message: "리뷰 삭제 중 오류", plugin: e.toString());
    }
  }
}
