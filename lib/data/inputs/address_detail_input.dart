import 'package:formz/formz.dart';

enum AddressDetailValidationError { invalid }

class AddressDetailInput
    extends FormzInput<String, AddressDetailValidationError> {
  const AddressDetailInput.pure([String value = '']) : super.pure(value);

  const AddressDetailInput.dirty([String value = '']) : super.dirty(value);

  @override
  AddressDetailValidationError? validator(String? value) {
    return value != null && value.isNotEmpty && value.length >= 5
        ? null
        : AddressDetailValidationError.invalid;
  }
}
