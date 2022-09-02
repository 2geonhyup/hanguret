import 'package:equatable/equatable.dart';

enum MainFilter { none, meal, alcohol, coffee }

enum MealSubFilter {
  spicy, // 매운게 땡겨
  cheap, // 값싸게 먹을래
  vibe, // 분위기 챙길래
  light, // 가볍게 먹을래
  warm, // 혼밥할거야
  greasy // 배에 기름칠
}

enum AlcoholSubFilter {
  cheap,
  beer, // 맥주
  wineCocktail,
  makgeoli,
  taste,
  turnDown // 조용한
}

enum CoffeeSubFilter { study, talk, vibe, desert, coffee, cheap }

class LocationFilter extends Equatable {
  final String name;
  final String station;

  LocationFilter({required this.name, String? station})
      : station = station ?? "";

  @override
  List<Object> get props => [name, station];
  @override
  bool get stringify => true;
}

class Filter extends Equatable {
  final MainFilter mainFilter;
  final List subFilterList;
  LocationFilter? locationFilter;

  Filter({required this.mainFilter, this.locationFilter, List? subFilterList})
      : subFilterList = subFilterList ?? [];

  @override
  List<Object> get props =>
      [mainFilter, subFilterList, locationFilter ?? "none"];
  @override
  bool get stringify => true;
}
