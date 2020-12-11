import 'package:hackernews_api/hackernews_api.dart';

class Result {
  final bool success;
  final String message;

  const Result._({this.success, this.message});

  const Result.success({String message})
      : this._(success: true, message: message);

  const Result.failure({String message})
      : this._(success: false, message: message);
}

extension ResponseX on Response {
  Result get getResult {
    if (success) {
      return Result.success(message: message);
    }
    return Result.failure(message: message);
  }
}
