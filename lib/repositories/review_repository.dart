import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:hangeureut/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

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

  Future<void> reviewComplete(
      {required String userId,
      required String userName,
      required String resId,
      required int score,
      File? imgFile,
      required int icon,
      required DateTime date,
      int? reviewId,
      String? imgUrl}) async {
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
    print(imgUrl);

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
          "imgUrl": imgUrl
        });
        Map responseMap = jsonDecode(response.body) as Map;
        reviewId = responseMap["reviewId"];
      } catch (e) {
        throw CustomError(
          code: "알림",
          message: "리뷰를 기록하는 과정에서 오류가 발생했습니다",
        );
      }
    } else {
      //리뷰 수정
      try {
        {
          Uri _uri = Uri.http(_url, '/reviews/$reviewId');
          var response = await http.put(_uri,
              body: {"score": "$score", "icon": "$icon", "imgUrl": imgUrl});
          print(response.body);
        }
      } catch (e) {
        throw CustomError(
          code: "알림",
          message: "리뷰를 수정하는 과정에서 오류가 발생했습니다",
        );
      }
    }

    if (reviewId == null) {
      throw const CustomError(code: "알림", message: "리뷰를 기록하는 과정에서 오류가 발생했습니다");
    }
    //리뷰 카운트 업데이트
    try {
      Uri _uri = Uri.http(_url, '/restaurants/count/:$resId');
      await http.put(_uri);
    } catch (e) {
      throw const CustomError(code: "알림", message: "리뷰를 기록하는 과정에서 오류가 발생했습니다");
    }

    //리뷰 아이디를 사용자 collection에 저장
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    await usersRef.doc(uid).collection("reviews").add({"id": reviewId});
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
      // Map body = jsonDecode(response.body) as Map;
      // if (body["success"] == false) {
      //   throw CustomError(code: "알림", message: "리뷰 삭제 중 오류");
      // }
    } catch (e) {
      throw CustomError(
          code: "알림", message: "리뷰 삭제 중 오류", plugin: e.toString());
    }
  }
}
