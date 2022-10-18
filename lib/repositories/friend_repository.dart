import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../constants.dart';
import '../models/custom_error.dart';
import '../models/friend.dart';

Future<List<MealFriend>> getFriendsDoc(friendsId) async {
  List<MealFriend> friendsList = [];

  for (String element in friendsId) {
    final DocumentSnapshot userDoc = await usersRef.doc(element).get();
    Map? data = userDoc.data() as Map<String, dynamic>?;
    MealFriend newFriend = MealFriend(
        id: userDoc.id,
        name: data!["name"],
        icon: data["icon"],
        cId: data["c-id"] ?? 1);
    friendsList.add(newFriend);
  }
  return friendsList;
}

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;

  FriendRepository({
    required this.firebaseFirestore,
  });
  Future<List<MealFriend>?> getKaKaoFriends() async {
    try {
      Friends friends = await TalkApi.instance.friends();
      List? friendsId =
          friends.elements?.map((friend) => "kakao:${friend.id}").toList();
      List<MealFriend> friendsList = [];
      if (friendsId == null) {
      } else {
        friendsList = await getFriendsDoc(friendsId);

        return friendsList;
      }
    } catch (e) {
      throw CustomError(
        code: '카카오친구받아오기 오류',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
