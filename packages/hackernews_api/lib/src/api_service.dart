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

  Future<Response> get(Request request) async {
    return _client.get(request.url);
  }

  Future<Response> post(Request request) async {
    return _client.post(request.url, data: request.data);
  }
}

class Request {
  final String url;
  final dynamic data;

  const Request(this.url, {this.data});
}
