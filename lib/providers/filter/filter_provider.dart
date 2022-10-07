import 'package:state_notifier/state_notifier.dart';

import '../../models/search_model.dart';
import 'filter_state.dart';

class SearchFilterProvider extends StateNotifier<SearchFilterState>
    with LocatorMixin {
  SearchFilterProvider() : super(SearchFilterState.initial());

  void changeFilter({MainFilter? mainFilter, String? subFilter}) {
    state = state.copyWith(
        filter: Filter(
            mainFilter: mainFilter ?? state.filter.mainFilter,
            subFilter: subFilter ?? state.filter.subFilter));
  }
}
