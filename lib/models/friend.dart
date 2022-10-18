import 'package:equatable/equatable.dart';

class MealFriend extends Equatable {
  final String id;
  final String name;
  final int icon;
  final String cId;

  const MealFriend({
    required this.id,
    required this.name,
    required this.icon,
    required this.cId,
  });

  @override
  List<Object> get props => [id, name, icon, cId];

  @override
  bool get stringify => true;
}
