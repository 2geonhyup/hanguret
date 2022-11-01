import 'package:hangeureut/models/search_model.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/widgets/error_dialog.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/restaurant_repository.dart';

class RestaurantsProvider extends StateNotifier<RestaurantsState>
    with LocatorMixin {
  RestaurantsProvider() : super(RestaurantsState.initial());

  // void addTodo(String todoDesc) {
  //   final newTodo = Todo(desc: todoDesc);
  //   final newTodos = [...state.todos, newTodo];
  //
  //   state = state.copyWith(todos: newTodos);
  //   print(state);
  // }
  Future<void> getRes({required bool sortType}) async {
    Map? restaurants;
    state = state.copyWith(resStatus: ResStatus.loading);
    try {
      restaurants =
          await read<RestaurantRepository>().getRestaurants(sortType: sortType);
    } catch (e) {
      rethrow;
    }

    state = state.copyWith(
        resStatus: ResStatus.loaded,
        allResult: restaurants ?? {0: [], 1: [], 2: []});
  }
}
