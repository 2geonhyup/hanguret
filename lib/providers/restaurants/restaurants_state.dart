import 'package:equatable/equatable.dart';

enum ResStatus {
  initial,
  loading,
  loaded,
}

class RestaurantsState extends Equatable {
  final Map allResult;
  final ResStatus resStatus;
  RestaurantsState({
    required this.resStatus,
    required this.allResult,
  });

  factory RestaurantsState.initial() {
    return RestaurantsState(
        resStatus: ResStatus.initial, allResult: {0: [], 1: [], 2: []});
  }

  @override
  List<Object> get props => [resStatus, allResult];

  @override
  bool get stringify => true;

  RestaurantsState copyWith({
    ResStatus? resStatus,
    Map? allResult,
  }) {
    return RestaurantsState(
      resStatus: resStatus ?? this.resStatus,
      allResult: allResult ?? this.allResult,
    );
  }
}
