import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import '../../repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  ProfileProvider() : super(ProfileState.initial());

  //editOnboarding -> 온보딩 정보 업데이트(firestore)
  //editName -> 이름 정보 업데이트(firestore)

  Future<void> getProfile({required String uid}) async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      final User user = await read<ProfileRepository>().getProfile(uid: uid);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      rethrow;
    }
  }

  Future<User?> getOthersProfile({required String uid}) async {
    try {
      final User user = await read<ProfileRepository>().getProfile(uid: uid);

      return user;
    } on CustomError catch (e) {
      rethrow;
    }
  }

  Future<void> setLogin() async {
    try {
      await read<ProfileRepository>().setLogin();
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
    User newUser = User(
        id: state.user.id,
        name: state.user.name,
        email: state.user.email,
        onboarding: state.user.onboarding,
        followings: state.user.followings,
        followers: state.user.followers,
        icon: state.user.icon,
        first: false);
    state = state.copyWith(user: newUser);
  }

  Future<void> setFriends(String id, String name, int icon) async {
    List newFriends = state.user.followings;
    newFriends.add({"id": id, "name": name, "icon": icon});
    try {
      await read<ProfileRepository>().setFollowings(
        id: id,
        name: name,
        icon: icon,
      );
      await read<ProfileRepository>()
          .setFollowers(followingId: id, currentUser: state.user);
      User newUser = User(
          id: state.user.id,
          name: state.user.name,
          email: state.user.email,
          onboarding: state.user.onboarding,
          followings: newFriends,
          followers: state.user.followers,
          icon: state.user.icon,
          first: state.user.first);
      state = state.copyWith(user: newUser);
      print("profileproviderrrr${state.user}");
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> removeFriends(String id, String name, int icon) async {
    List newFriends = [];
    for (var friend in state.user.followings) {
      if (id != friend["id"]) {
        newFriends.add(friend);
      }
    }

    try {
      await read<ProfileRepository>()
          .setFollowings(id: id, name: name, icon: icon, remove: true);
      User newUser = User(
          id: state.user.id,
          name: state.user.name,
          email: state.user.email,
          onboarding: state.user.onboarding,
          followings: newFriends,
          followers: state.user.followers,
          icon: state.user.icon,
          first: state.user.first);
      state = state.copyWith(user: newUser);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> setName({required String? name}) async {
    if (name == null || name == "") {
      throw CustomError(
        code: 'Exception',
        message: "이름은 한글자 이상이어야 합니다",
      );
    }
    try {
      await read<ProfileRepository>().setName(name: name);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
    User newUser = User(
        id: state.user.id,
        name: name,
        email: state.user.email,
        onboarding: state.user.onboarding,
        followings: state.user.followings,
        followers: state.user.followers,
        icon: state.user.icon,
        first: state.user.first);
    state = state.copyWith(user: newUser);
  }

  Future<void> setOnboarding({required Map onboarding}) async {
    final tasteCnt = onboarding["tasteKeyword"]
        .entries
        .where((e) => e.value == true)
        .toList()
        .length;
    final alcoholCnt = onboarding["alcoholType"]
        .entries
        .where((e) => e.value == true)
        .toList()
        .length;
    if (tasteCnt < 2) {
      throw CustomError(message: "입맛 키워드는 2개 이상 선택해주세요");
    } else if (alcoholCnt == 0) {
      throw CustomError(message: "주종은 1개 이상 선택해주세요");
    }
    try {
      await read<ProfileRepository>().setOnboarding(onboarding: onboarding);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
    User newUser = User(
      id: state.user.id,
      name: state.user.name,
      email: state.user.email,
      onboarding: onboarding,
      followings: state.user.followings,
      followers: state.user.followers,
      icon: state.user.icon,
      first: state.user.first,
    );
    state = state.copyWith(user: newUser);
  }
}
