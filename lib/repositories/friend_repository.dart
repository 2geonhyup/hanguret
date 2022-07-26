import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;

  FriendRepository({
    required this.firebaseFirestore,
  });
  Future<void> getFriends() async {
    print("here");
    User user = await UserApi.instance.me();

    print("userkakaoinfo!!!!!!: ${user.id}");
    try {
      TalkProfile profile = await TalkApi.instance.profile();
      print('카카오톡 프로필 받기 성공'
          '\n닉네임: ${profile.nickname}'
          '\n프로필사진: ${profile.thumbnailUrl}');
    } catch (error) {
      print('카카오톡 프로필 받기 실패 $error');
    }
    try {
      Friends friends = await TalkApi.instance.friends();
      print('카카오톡 친구 목록 받기 성공'
          '\n${friends.elements?.map((friend) => friend.profileNickname).join('\n')}');
    } catch (error) {
      print('카카오톡 친구 목록 받기 실패 $error');
    }
  }
}
