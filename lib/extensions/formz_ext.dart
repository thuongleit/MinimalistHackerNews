import 'package:formz/formz.dart';

extension FormzX on FormzStatus {
  bool get isSubmitted => (this == FormzStatus.submissionInProgress ||
      this == FormzStatus.submissionSuccess ||
      this == FormzStatus.submissionFailure);
}
