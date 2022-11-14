import 'package:hangeureut/providers/location/location_state.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/repositories/restaurant_repository.dart';
import 'package:location/location.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../models/custom_error.dart';
import '../../models/search_model.dart';
import '../filter/filter_state.dart';
import '../result/result_state.dart';
import 'distance_state.dart';

class DistanceProvider extends StateNotifier<DistanceState> with LocatorMixin {
  DistanceProvider() : super(DistanceState.initial());

  Future<String> getDistance(
      {required String address,
      required String resId,
      required LocationData locationData}) async {
    Map distanceMap = state.distanceMap;

    if (distanceMap.containsKey(resId) && distanceMap[resId] != "-") {
      return distanceMap[resId];
    } else if (locationData.latitude == null ||
        locationData.longitude == null) {
      return "-";
    } else {
      try {
        int distance = await read<RestaurantRepository>().getDistance(
            address: address,
            userLat: locationData.latitude!,
            userLong: locationData.longitude!);
        if (distance == -1) {
          return "-";
        } else {
          //정상적으로 거리 받아온 경우만 호출
          String distanceString = distance < 1000
              ? '${distance}m'
              : '${(distance / 1000.0).toStringAsFixed(1)}km';
          distanceMap[resId] = distanceString;
          state = state.copyWith(distanceMap: distanceMap);
          return distanceString;
        }
      } on CustomError catch (e) {
        return "-";
      }
    }
  }
}
