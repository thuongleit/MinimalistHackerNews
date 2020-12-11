part of 'user_input_bloc.dart';

class UserInputState extends Equatable {
  const UserInputState({
    this.status = FormzStatus.pure,
    this.input = const InputField.pure(),
    this.message,
  });

  final FormzStatus status;
  final InputField input;
  final String message;

  UserInputState copyWith({
    FormzStatus status,
    InputField value,
    String message,
  }) {
    return UserInputState(
      status: status ?? this.status,
      input: value ?? this.input,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [status, input, message];
}
