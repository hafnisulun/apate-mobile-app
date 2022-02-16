import 'package:formz/formz.dart';

enum ResidenceValidationError { invalid }

class ResidenceInput extends FormzInput<String, ResidenceValidationError> {
  const ResidenceInput.pure([String value = '']) : super.pure(value);

  const ResidenceInput.dirty([String value = '']) : super.dirty(value);

  @override
  ResidenceValidationError? validator(String? value) {
    print("[validator] value: $value");
    return value != null && value.isNotEmpty && value.length >= 3
        ? null
        : ResidenceValidationError.invalid;
  }
}
