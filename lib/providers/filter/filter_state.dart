import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:hangeureut/models/search_model.dart';

class SearchFilterState extends Equatable {
  final Filter filter;
  SearchFilterState({required this.filter});

  factory SearchFilterState.initial() {
    return SearchFilterState(filter: Filter(mainFilter: MainFilter.none));
  }

  @override
  List<Object> get props => [filter];

  @override
  bool get stringify => true;

  SearchFilterState copyWith({Filter? filter}) {
    return SearchFilterState(filter: filter ?? this.filter);
  }
}
