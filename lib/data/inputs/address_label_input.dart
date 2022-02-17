import 'package:formz/formz.dart';

enum AddressLabelValidationError { invalid }

class AddressLabelInput
    extends FormzInput<String, AddressLabelValidationError> {
  const AddressLabelInput.pure([String value = '']) : super.pure(value);

  const AddressLabelInput.dirty([String value = '']) : super.dirty(value);

  @override
  AddressLabelValidationError? validator(String? value) {
    return value != null && value.isNotEmpty && value.length >= 3
        ? null
        : AddressLabelValidationError.invalid;
  }
}
