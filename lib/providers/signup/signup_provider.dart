// import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';
import 'signup_state.dart';

// class SignupProvider with ChangeNotifier {
class SignupProvider extends StateNotifier<SignupState> with LocatorMixin {
  // SignupState _state = SignupState.initial();
  // SignupState get state => _state;
  SignupProvider() : super(SignupState.initial());

  Future<void> appleSignUp() async {
    state = state.copyWith(signupStatus: SignupStatus.submitting);
    try {
      await read<AuthRepository>().appleLogin();
      state = state.copyWith(signupStatus: SignupStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signupStatus: SignupStatus.error, error: e);
      rethrow;
    }
  }

  Future<void> signup() async {
    state = state.copyWith(signupStatus: SignupStatus.submitting);
    try {
      await read<AuthRepository>().loginOrSignup();
      state = state.copyWith(signupStatus: SignupStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signupStatus: SignupStatus.error, error: e);
      rethrow;
    }
  }

  void signOutComp() {
    state = state.copyWith(signupStatus: SignupStatus.initial);
  }
}
