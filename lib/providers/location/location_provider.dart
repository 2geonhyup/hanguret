import 'package:location/location.dart';
import 'package:state_notifier/state_notifier.dart';

import 'location_state.dart';

class LocationProvider extends StateNotifier<LocationState> with LocatorMixin {
  LocationProvider() : super(LocationState.unknown());

  @override
  void update(Locator watch) {
    final LocationData? locationData = watch<LocationData?>();
    if (locationData != null) {
      state = state.copyWith(
        locationStatus: LocationStatus.known,
        locationData: locationData,
      );
    } else {
      state = state.copyWith(locationStatus: LocationStatus.unknown);
    }

    // TODO: implement update
    super.update(watch);
  }

  // Future<void> setLocationAgree() async {
  //   Location location = Location();
  //   bool _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       state.copyWith(locationStatus: LocationStatus.unknown);
  //       return;
  //     }
  //   }
  //
  //   PermissionStatus _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       state.copyWith(locationStatus: LocationStatus.denied);
  //       return;
  //     }
  //   }
  //   state.copyWith(locationStatus: LocationStatus.known);
  // }
}
