import 'package:hangeureut/providers/news/news_state.dart';
import 'package:hangeureut/repositories/news_repository.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/news_model.dart';

class NewsProvider extends StateNotifier<NewsState> with LocatorMixin {
  NewsProvider() : super(NewsState.initial());

  @override
  void update(Locator watch) {
    final newsList = watch<List<News>>();
    bool watched = true;
    for (var i in state.newsList) {
      if (!i.watched) watched = false;
    }

    state = state.copyWith(newsList: newsList, watched: watched);
    super.update(watch);
  }

  Future<void> watchNews() async {
    final newsList = state.newsList;
    final updateList = newsList
        .map((e) => News(watched: true, type: e.type, content: e.content))
        .toList();
    state = state.copyWith(newsList: updateList, watched: true);
    await read<NewsRepository>().setWatchedNews();
  }
}
