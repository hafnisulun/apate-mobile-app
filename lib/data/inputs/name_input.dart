import 'package:formz/formz.dart';

enum NameInputValidationError { invalid }

class NameInput extends FormzInput<String, NameInputValidationError> {
  const NameInput.pure([String value = '']) : super.pure(value);

  const NameInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameInputValidationError? validator(String? value) {
    return value != null && value.isNotEmpty && value.length >= 3
        ? null
        : NameInputValidationError.invalid;
  }
}
