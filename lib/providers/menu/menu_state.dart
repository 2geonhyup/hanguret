import 'package:equatable/equatable.dart';

class MenuState extends Equatable {
  final int index;

  MenuState({required this.index});

  factory MenuState.initial() {
    return MenuState(index: 0);
  }

  @override
  List<Object> get props => [index];

  @override
  bool get stringify => true;

  MenuState copyWith({
    int? index,
  }) {
    return MenuState(
      index: index ?? this.index,
    );
  }
}
