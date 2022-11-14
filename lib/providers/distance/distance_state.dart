import 'package:equatable/equatable.dart';

class DistanceState extends Equatable {
  final Map distanceMap;

  const DistanceState({
    required this.distanceMap,
  });

  factory DistanceState.initial() {
    return DistanceState(
      distanceMap: {},
    );
  }

  @override
  List<Object> get props => [distanceMap];

  @override
  bool get stringify => true;

  DistanceState copyWith({Map? distanceMap}) {
    return DistanceState(
      distanceMap: distanceMap ?? this.distanceMap,
    );
  }
}
