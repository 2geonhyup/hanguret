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
    print("profileprovuid${uid}");
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      final User user = await read<ProfileRepository>().getProfile(uid: uid);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      rethrow;
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
    );
    state = state.copyWith(user: newUser);
  }

  Future<void> setOnboarding({required Map onboarding}) async {
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
    );
    state = state.copyWith(user: newUser);
  }
}
