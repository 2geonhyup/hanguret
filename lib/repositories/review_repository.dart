import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hangeureut/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

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

  Future<void> reviewComplete({
    required String userId,
    required String userName,
    required String resId,
    required int score,
    required File imgFile,
    required int icon,
    required DateTime date,
  }) async {
    try {
      String dirPath = await getStorageDirectory();
      await imgFile.copy("$dirPath/$resId$userId");
    } catch (e) {
      print(e);
    }
    //   //리뷰를 백엔드 서버에 등록하기
    //   DocumentReference document =
    //       await FirebaseFirestore.instance.collection("reviews").add({
    //     "userId": userId,
    //     "userName": userName,
    //     "resId": resId,
    //     "score": score,
    //     "image": imgPath,
    //     "icon": icon,
    //     "date": date,
    //   });
    //   //리뷰 아이디를 사용자 collection에 저장
    //   String reviewId = document.id;
    //   final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    //   await usersRef.doc(uid).collection("reviews").add({"id": reviewId});
    // }
  }
}
