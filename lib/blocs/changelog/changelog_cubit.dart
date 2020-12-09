import 'package:http/http.dart' as http;

import '../../blocs/network/network_cubit.dart';
import '../../const.dart';

class ChangelogCubit extends NetworkCubit<String> {
  final http.Client _client;
  String _url;

  ChangelogCubit({http.Client client}) : this._client = client ?? http.Client();

  Future<void> getChangelog({String url = Const.changelog}) async {
    assert(url != null);
    emit(NetworkState.loading());
    try {
      this._url = url;
      var response = await _client.get(_url);

      emit(NetworkState.success(response.body));
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
