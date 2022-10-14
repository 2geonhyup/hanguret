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

class Filter extends Equatable {
  final MainFilter mainFilter;
  final int subFilter;

  Filter({required this.mainFilter, int? subFilter})
      : subFilter = subFilter ?? -1;
  //-1 은 전체를 의미

  @override
  List<Object> get props => [mainFilter, subFilter];
  @override
  bool get stringify => true;
}
