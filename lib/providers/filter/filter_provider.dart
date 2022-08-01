import 'package:state_notifier/state_notifier.dart';

import '../../models/search_model.dart';
import 'filter_state.dart';

class SearchFilterProvider extends StateNotifier<SearchFilterState>
    with LocatorMixin {
  SearchFilterProvider() : super(SearchFilterState.initial());

  void changeFilter(Filter newFilter) {
    state = state.copyWith(filter: newFilter);
  }

  get subFilters => state.filter.subFilterList;
  get locationFilter => state.filter.locationFilter;

  void addSubFilter(newSubFilter) {
    Filter currentFilter = state.filter;
    List currentSubFilters = currentFilter.subFilterList;
    if (!currentSubFilters.contains(newSubFilter)) {
      currentSubFilters.add(newSubFilter);
    } else {
      currentSubFilters.remove(newSubFilter);
    }
    Filter newFilter = Filter(
        mainFilter: currentFilter.mainFilter,
        subFilterList: currentSubFilters,
        locationFilter: currentFilter.locationFilter);
    state = state.copyWith(filter: newFilter);
    print(state);
  }
}
