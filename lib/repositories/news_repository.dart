import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/models/news_model.dart';
import 'package:http/http.dart' as http;

String _url = 'ec2-3-35-52-247.ap-northeast-2.compute.amazonaws.com:3001';

class NewsRepository {
  final FirebaseFirestore firebaseFirestore;
  NewsRepository({required this.firebaseFirestore});

  Stream<List<News>> get news async* {
    DateTime newsWatchedTime;
    try {
      final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await usersRef.doc(uid).get();
      if (userDoc.data()!.containsKey("newsWatchedTime")) {
        newsWatchedTime = userDoc.data()!["newsWatchedTime"].toDate();
      } else {
        newsWatchedTime = DateTime.now().subtract(Duration(days: 30));
        await usersRef.doc(uid).update({"newsWatchedTime": DateTime.now()});
      }
      Stream<QuerySnapshot> newsStream = usersRef
          .doc(uid)
          .collection('news')
          .orderBy('date', descending: true)
          .snapshots();

      await for (QuerySnapshot q in newsStream) {
        List<News> newsToReturn = [];

        for (var doc in q.docs) {
          final newsDoc = doc.data() as Map<String, dynamic>;
          Map content = newsDoc["content"];
          if (newsDoc["type"] == 1) {
            newsToReturn.add(News(
                type: newsDoc["type"],
                watched:
                    newsWatchedTime.compareTo(newsDoc["date"].toDate()) > 0,
                content: FriendsNews(
                  userId: content["id"],
                  userName: content["name"] ?? "",
                  userIcon: content["icon"] ?? 0,
                  cId: content["cId"] ?? "",
                )));
          } else if (newsDoc["type"] == 2) {
            newsToReturn.add(News(
                type: newsDoc["type"],
                watched:
                    newsWatchedTime.compareTo(newsDoc["date"].toDate()) > 0,
                content: ReviewNews(
                    userId: content["id"],
                    userIcon: content["icon"] ?? 0,
                    userName: content["name"] ?? "",
                    resName: content["resName"] ?? "",
                    cId: content["cId"] ?? "")));
          } else if (newsDoc["type"] == 3) {
            newsToReturn.add(News(
                type: newsDoc["type"],
                watched:
                    newsWatchedTime.compareTo(newsDoc["date"].toDate()) > 0,
                content: HangerutNews(
                    title: content["title"],
                    content: content["content"],
                    navigate: content["navigate"])));
          }
        }
        yield newsToReturn;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setWatchedNews() async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    await usersRef.doc(uid).update({"newsWatchedTime": DateTime.now()});
  }

  Future<List<Map>> getFriendsNews({required List friendsIds}) async {
    List<Map> responseList = [];
    // 유저의 친구들 목록 보내는 코드
    for (var userId in friendsIds) {
      try {
        Uri _uri = Uri.http(_url, '/reviews/user/$userId');
        var response = await http.get(_uri);

        List reviewList = jsonDecode(response.body) as List;

        for (Map review in reviewList) {
          DateTime val = DateTime.parse(review["date"]);
          if (val.difference(DateTime.now()).inDays > 10) continue;
          review["dateOrigin"] = review["date"];
          review["date"] = "${val.year}년 ${val.month}월 ${val.day}일";
          responseList.add(review);
        }
      } catch (e) {
        throw const CustomError(
            code: "알림", message: "소식을 받아오는 과정에서 문제가 발생했습니다");
      }
    }
    responseList.sort((a, b) => DateTime.parse(b["dateOrigin"])
        .compareTo(DateTime.parse(a["dateOrigin"])));
    return responseList;
  }

  Future<List<Map>> getRecoNews() async {
    return [];
  }
}
