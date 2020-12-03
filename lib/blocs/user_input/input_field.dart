import 'package:formz/formz.dart';

enum InputFieldValidationError { empty }

class InputField extends FormzInput<String, InputFieldValidationError> {
  const InputField.pure() : super.pure('');

  const InputField.dirty([String value = '']) : super.dirty(value);

  @override
  InputFieldValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : InputFieldValidationError.empty;
  }
}
