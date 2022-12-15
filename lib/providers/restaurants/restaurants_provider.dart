import 'package:geolocator/geolocator.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
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

  //mainfilter의 변화가 있을 때, 해당 필터에 해당하는
  Future<void> getRes({required bool sortType}) async {
    List<Map> allRes;
    List<Map> resList0 = [];
    List<Map> resList1 = [];
    List<Map> resList2 = [];
    Map rankingListY = {};
    Map rankingListS = {};
    Map rankingListE = {};
    state = state.copyWith(resStatus: ResStatus.loading);
    try {
      allRes = await read<RestaurantRepository>()
              .getRestaurants(sortType: sortType) ??
          [];
      for (var res in allRes) {
        if (res["ranking"] != null) {
          List allRank = res["ranking"].split(",");
          for (var rank in allRank) {
            if (rank.contains("Yonsei")) {
              String rankString = rank.replaceAll("Yonsei", "");
              rankingListY[int.parse(rankString)] = res;
            } else if (rank.contains("Sogang")) {
              String rankString = rank.replaceAll("Sogang", "");
              rankingListS[int.parse(rankString)] = res;
            } else if (rank.contains("Ewha")) {
              String rankString = rank.replaceAll("Ewha", "");
              rankingListE[int.parse(rankString)] = res;
            }
          }
        }

        if (res["category1"] == 0 || res["category2"] == 0) {
          resList0.add(res);
        }
        if (res["category1"] == 1 || res["category2"] == 1) {
          resList1.add(res);
        }
        if (res["category1"] == 2 || res["category2"] == 2) {
          resList2.add(res);
        }
      }
    } catch (e) {
      rethrow;
    }

    state = state.copyWith(
        resStatus: ResStatus.loaded,
        allRes: allRes,
        allResult: {
          0: resList0,
          1: resList1,
          2: resList2
        },
        ranking: {
          "Yonsei": rankingListY,
          "Sogang": rankingListS,
          "Ewha": rankingListE
        });
  }

  List getResByReviewCnt() {
    var _allRes = state.allRes;
    List result = [];
    for (var i = 0; i < 10; i++) {
      dynamic max = _allRes.firstWhere((element) => !result.contains(element));
      _allRes.forEach((e) {
        if (e['reviewCnt'] > max['reviewCnt'] && !result.contains(e)) max = e;
      });
      result.add(max);
    }

    return result;
  }

  Future<int> getDistance(
      {required String address,
      required int resId,
      required Position locationData,
      required int mainFilterNum}) async {
    int distance = -1;
    try {
      distance = await read<RestaurantRepository>().getDistance(
          address: address,
          userLat: locationData.latitude,
          userLong: locationData.longitude);
      return distance;
    } on CustomError catch (e) {
      return -1;
    }
  }
}
