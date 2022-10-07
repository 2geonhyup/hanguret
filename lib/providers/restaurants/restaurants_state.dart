import 'package:equatable/equatable.dart';

enum ResStatus {
  initial,
  loading,
  loaded,
}

class RestaurantsState extends Equatable {
  final List<Map> allResult;
  final ResStatus resStatus;
  RestaurantsState({
    required this.resStatus,
    required this.allResult,
  });

  factory RestaurantsState.initial() {
    return RestaurantsState(resStatus: ResStatus.initial, allResult: []);
  }

  @override
  List<Object> get props => [resStatus, allResult];

  @override
  bool get stringify => true;

  RestaurantsState copyWith({
    ResStatus? resStatus,
    List<Map>? allResult,
  }) {
    return RestaurantsState(
      resStatus: resStatus ?? this.resStatus,
      allResult: allResult ?? this.allResult,
    );
  }
}
