import 'package:hangeureut/providers/menu/menu_state.dart';
import 'package:state_notifier/state_notifier.dart';

class MenuProvider extends StateNotifier<MenuState> {
  MenuProvider() : super(MenuState.initial());

  void changeMenu(int newIndex) {
    state = state.copyWith(index: newIndex);
  }
}
