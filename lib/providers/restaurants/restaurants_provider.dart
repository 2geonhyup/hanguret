import 'package:hangeureut/models/search_model.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
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
  Future<void> getRes(
      {required MainFilter mainFilter, required bool sortType}) async {
    List<Map>? restaurants;
    int mainFilterNum = 0;
    state = state.copyWith(resStatus: ResStatus.loading);
    switch (mainFilter) {
      case MainFilter.alcohol:
        {
          mainFilterNum = 1;
          break;
        }
      case MainFilter.coffee:
        {
          mainFilterNum = 2;
          break;
        }
      default:
        break;
    }
    restaurants = await read<RestaurantRepository>()
        .getRestaurants(mainFilterNum: mainFilterNum, sortType: sortType);
    state = state.copyWith(
        resStatus: ResStatus.loaded, allResult: restaurants ?? []);
  }
}
