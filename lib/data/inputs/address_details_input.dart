import 'package:formz/formz.dart';

enum AddressDetailsValidationError { invalid }

class AddressDetailsInput
    extends FormzInput<String, AddressDetailsValidationError> {
  const AddressDetailsInput.pure([String value = '']) : super.pure(value);

  const AddressDetailsInput.dirty([String value = '']) : super.dirty(value);

  @override
  AddressDetailsValidationError? validator(String? value) {
    return value != null && value.isNotEmpty && value.length >= 5
        ? null
        : AddressDetailsValidationError.invalid;
  }
}
