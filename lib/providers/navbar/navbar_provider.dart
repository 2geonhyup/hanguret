import 'package:state_notifier/state_notifier.dart';

import 'navbar_state.dart';

class NavBarProvider extends StateNotifier<NavBarState> with LocatorMixin {
  NavBarProvider() : super(NavBarState.initial());
  void changeNavBarShow() {
    state = state.copyWith(show: !state.show);
  }
}
