import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hangeureut/repositories/auth_repository.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/contents_repository.dart';
import 'content_state.dart';

// auth provider 는 user state가 변할 때마다 update가 되어야 함
//s state notifier는 locator mixin을 통해 다른 provider에 접근할 수 있는 것이 큰 장점!
class ContentProvider extends StateNotifier<ContentState> with LocatorMixin {
  ContentProvider() : super(ContentState.unknown());

  Future<void> getContents() async {
    try {
      state = state.copyWith(contentStatus: ContentStatus.loading);
      Map _contents = await read<ContentsRepository>().getContents();
      state = state.copyWith(
          contents: _contents, contentStatus: ContentStatus.loaded);
    } catch (e) {
      rethrow;
    }
  }
}
