import 'package:dio/dio.dart';
import 'package:hacker_news/const.dart';

import '../../blocs/network/network_cubit.dart';

class ChangelogCubit extends NetworkCubit<String> {
  final Dio _client;
  String _url;

  ChangelogCubit({Dio client}) : this._client = client ?? Dio();

  Future<void> getChangelog({String url = Const.changelog}) async {
    assert(url != null);
    emit(NetworkState.loading());
    try {
      this._url = url;
      var response = await _client.get(_url);

      emit(NetworkState.success(response.data));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }

  @override
  Future<void> refresh() async {
    if (_url == null) {
      return;
    }
    return getChangelog(url: _url);
  }
}
