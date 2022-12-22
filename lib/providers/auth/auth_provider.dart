import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hangeureut/repositories/auth_repository.dart';
import 'package:state_notifier/state_notifier.dart';

import 'auth_state.dart';

// auth provider 는 user state가 변할 때마다 update가 되어야 함
//s state notifier는 locator mixin을 통해 다른 provider에 접근할 수 있는 것이 큰 장점!
class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.unknown());

  @override
  void update(Locator watch) {
    final user = watch<fbAuth.User?>();
    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }

    super.update(watch);
  }

  void signout() async {
    await read<AuthRepository>().signout();
  }
}
