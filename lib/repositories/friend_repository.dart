import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;

  FriendRepository({
    required this.firebaseFirestore,
  });
  Future<List?> getKaKaoFriends() async {
    try {
      Friends friends = await TalkApi.instance.friends();
      List? fridndsId =
          friends.elements?.map((friend) => "kakao:${friend.id}").toList();
      List friendsList = [];
      if (fridndsId == null) {
      } else {
        fridndsId.forEach((element) async {
          final DocumentSnapshot userDoc = await usersRef.doc(element).get();
          friendsList.add(userDoc.data());
        });
        return friendsList;
      }
    } catch (error) {
      print('카카오톡 친구 목록 받기 실패 $error');
    }
  }
}
