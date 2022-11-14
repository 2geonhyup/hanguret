import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

enum LocationStatus { unknown, known, denied }

class LocationState extends Equatable {
  final LocationStatus locationStatus;
  final LocationData? location;

  LocationState({
    required this.locationStatus,
    this.location,
  });

  factory LocationState.unknown() {
    return LocationState(locationStatus: LocationStatus.unknown);
  }

  @override
  List<Object?> get props => [locationStatus, location];

  @override
  bool get stringify => true;

  LocationState copyWith({
    LocationStatus? locationStatus,
    LocationData? locationData,
  }) {
    return LocationState(
      locationStatus: locationStatus ?? this.locationStatus,
      location: location ?? this.location,
    );
  }
}
