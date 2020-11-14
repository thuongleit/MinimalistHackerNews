import 'package:dio/dio.dart';
import 'package:hacker_news/blocs/network/network_bloc.dart';

class ChangelogCubit extends NetworkCubit<String> {
  final String url;
  final Dio _client;

  ChangelogCubit(this.url, {Dio client})
      : assert(url != null),
        this._client = client ?? Dio();

  @override
  Future<void> fetchData() async {
    try {
      var response = await _client.get(url);

      emit(NetworkState.success(response.data));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
