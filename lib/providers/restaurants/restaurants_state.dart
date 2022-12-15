import 'package:equatable/equatable.dart';

enum ResStatus {
  initial,
  loading,
  loaded,
}

class RestaurantsState extends Equatable {
  final List allRes;
  final Map allResult;
  final Map allResultByDistance;
  final ResStatus resStatus;
  final Map<String, Map> ranking;
  RestaurantsState(
      {required this.allRes,
      required this.resStatus,
      required this.allResult,
      required this.ranking,
      required this.allResultByDistance});

  factory RestaurantsState.initial() {
    return RestaurantsState(
        resStatus: ResStatus.initial,
        allRes: const [],
        allResult: const {
          0: [],
          1: [],
          2: []
        },
        allResultByDistance: const {
          0: [],
          1: [],
          2: []
        },
        ranking: const {
          "Yonsei": {},
          "Sogang": {},
          "Ewha": {},
        });
  }

  @override
  List<Object> get props => [resStatus, allResult];

  @override
  bool get stringify => true;

  RestaurantsState copyWith({
    ResStatus? resStatus,
    List? allRes,
    Map? allResult,
    Map<String, Map>? ranking,
    Map? allResultByDistance,
  }) {
    return RestaurantsState(
        allRes: allRes ?? this.allRes,
        resStatus: resStatus ?? this.resStatus,
        allResult: allResult ?? this.allResult,
        ranking: ranking ?? this.ranking,
        allResultByDistance: allResultByDistance ?? this.allResultByDistance);
  }
}
