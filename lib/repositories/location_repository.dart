import 'package:location/location.dart';

class LocationRepository {
  Location location;
  LocationRepository({required this.location});

  Stream<LocationData?> get getLocation async* {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 100, distanceFilter: 5);
    yield* location.onLocationChanged;
  }
}
