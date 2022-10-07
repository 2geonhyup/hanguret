import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/models/custom_error.dart';
import 'package:hangeureut/models/news_model.dart';
import 'package:hangeureut/providers/profile/profile_state.dart';
import 'package:hangeureut/screens/news_screen/news_output.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:provider/provider.dart';

class NewsRepository {
  final FirebaseFirestore firebaseFirestore;
  NewsRepository({required this.firebaseFirestore});

  Stream<List<News>> get news async* {
    DateTime newsWatchedTime;
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await usersRef.doc(uid).get();
    if (userDoc.data()!.containsKey("newsWatched")) {
      newsWatchedTime = userDoc.data()!["newsWatched"].toDate();
    } else {
      newsWatchedTime = DateTime.now().subtract(Duration(days: 30));
      await usersRef.doc(uid).set({"newsWatchedTime": DateTime.now()});
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
        if (newsDoc["type"] == 0) {
          newsToReturn.add(News(
              type: newsDoc["type"],
              watched: newsWatchedTime.compareTo(newsDoc["date"].toDate()) > 0,
              content: FriendsNews(
                userId: content["id"],
                userName: content["name"],
                userIcon: content["icon"],
              )));
        } else if (newsDoc["type"] == 1) {
          newsToReturn.add(News(
              type: newsDoc["type"],
              watched: newsWatchedTime.compareTo(newsDoc["date"].toDate()) > 0,
              content: ReviewNews(
                  userId: content["id"],
                  userIcon: content["icon"],
                  userName: content["name"],
                  resName: content["resName"])));
        } else if (newsDoc["type"] == 2) {
          newsToReturn.add(News(
              type: newsDoc["type"],
              watched: newsWatchedTime.compareTo(newsDoc["date"].toDate()) > 0,
              content: HangerutNews(
                  title: content["title"],
                  content: content["content"],
                  navigate: content["navigate"])));
        }
      }
      yield newsToReturn;
    }
  }

  Future<void> setWatchedNews() async {
    final String uid = fbAuth.FirebaseAuth.instance.currentUser!.uid;
    await usersRef.doc(uid).update({"newsWatched": DateTime.now()});
  }

  Future<List<Map<String, Object>>> getFriendsNews(
      {required List friendsIds}) async {
    // 유저의 친구들 목록 보내는 코드
    await Future.delayed(Duration(milliseconds: 500));
    return newsOutputFriends;
  }

  Future<List<Map>> getRecoNews() async {
    await Future.delayed(Duration(milliseconds: 500));

    return newsOutputReco;
  }
}
