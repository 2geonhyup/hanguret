import 'package:equatable/equatable.dart';

class ResultState extends Equatable {
  final List<Map> filteredResult;
  ResultState({
    required this.filteredResult,
  });

  factory ResultState.initial() {
    return ResultState(filteredResult: []);
  }

  @override
  List<Object> get props => [filteredResult];

  @override
  bool get stringify => true;

  ResultState copyWith({
    List<Map>? filteredResult,
    List<Map>? allResult,
  }) {
    return ResultState(
      filteredResult: filteredResult?? this.filteredResult,
    );
  }
}