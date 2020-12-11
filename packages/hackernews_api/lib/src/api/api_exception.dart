class HackerNewsApiException implements Exception {
  final int errorCode;
  final String message;

  const HackerNewsApiException({this.errorCode, this.message});
}
