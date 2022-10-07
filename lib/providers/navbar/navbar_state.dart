import 'package:equatable/equatable.dart';

class NavBarState extends Equatable {
  final bool show;
  NavBarState({
    required this.show,
  });

  factory NavBarState.initial() {
    return NavBarState(show: true);
  }

  @override
  List<Object> get props => [show];

  @override
  bool get stringify => true;

  NavBarState copyWith({bool? show}) {
    return NavBarState(
      show: show ?? this.show,
    );
  }
}
