import 'package:hangeureut/models/search_model.dart';
import 'package:hangeureut/providers/filter/filter_state.dart';
import 'package:hangeureut/providers/restaurants/restaurants_state.dart';
import 'package:hangeureut/providers/result/result_state.dart';
import 'package:state_notifier/state_notifier.dart';

class ResultProvider extends StateNotifier<ResultState> with LocatorMixin {
  ResultProvider() : super(ResultState.initial());

  @override
  void update(Locator watch) {
    final Filter filter = watch<SearchFilterState>().filter;
    final List<Map> _allResult = watch<RestaurantsState>().allResult;

    List<Map> _filteredResult;

    if (filter.subFilter == -1) {
      _filteredResult = _allResult;
    } else {
      _filteredResult = _allResult
          .where((Map restaurant) =>
              restaurant["tag1"] == filter.subFilter ||
              restaurant["tag2"] == filter.subFilter)
          .toList();
    }

    state = state.copyWith(filteredResult: _filteredResult);

    super.update(watch);
  }
}
