import 'package:location/location.dart';

//위치 받아오기 전에 호출해서 권한 설정하지 않은 경우 해당 기능(거리, 지도 길찾기) 쓸수 없게 함

Future<LocationData?> getLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();
}
