import 'dart:async';
import 'package:dio/dio.dart';

/// Serves data to several data repositories.
///
/// Makes http calls to several services, including
/// the open source r/HackerNews REST API.
class HackerNewsApiClient {
  static final HackerNewsApiClient _api = HackerNewsApiClient._internal();
  static final Dio _client = Dio();

  //private internal constructor to make it singleton
  HackerNewsApiClient._internal();

  factory HackerNewsApiClient() => _api;

  Future<Response> perform(Request request) async {
    return _client.get(request.url);
  }
}

class Request {
  final String url;

  const Request(this.url);
}