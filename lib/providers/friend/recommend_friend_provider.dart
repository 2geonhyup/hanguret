import 'package:hangeureut/models/friend.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import '../../repositories/friend_repository.dart';
import '../../repositories/profile_repository.dart';
import '../profile/profile_state.dart';
import 'recommend_friend_state.dart';

class RecommendFriendProvider extends StateNotifier<RecommendFriendState>
    with LocatorMixin {
  RecommendFriendProvider() : super(RecommendFriendState.initial());

  //editOnboarding -> 온보딩 정보 업데이트(firestore)
  //editName -> 이름 정보 업데이트(firestore)

  Future<void> getRecommendFriends() async {
    try {
      final List<MealFriend>? kakaoFriends =
          await read<FriendRepository>().getKaKaoFriends();
      //TODO: 여기에서 진짜 친구는 제외하는 과정도 거쳐야함

      state = state.copyWith(recommendFriends: kakaoFriends);
    } on CustomError catch (e) {
      rethrow;
    }
  }
}
