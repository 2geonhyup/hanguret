import 'package:equatable/equatable.dart';

class MealFriend extends Equatable {
  final String id;
  final String name;
  final int icon;

  const MealFriend({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [id, name, icon];

  @override
  bool get stringify => true;
}
