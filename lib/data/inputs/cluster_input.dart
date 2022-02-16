import 'package:formz/formz.dart';

enum ClusterValidationError { invalid }

class ClusterInput extends FormzInput<String, ClusterValidationError> {
  const ClusterInput.pure([String value = '']) : super.pure(value);

  const ClusterInput.dirty([String value = '']) : super.dirty(value);

  @override
  ClusterValidationError? validator(String? value) {
    return value != null && value.isNotEmpty && value.length >= 3
        ? null
        : ClusterValidationError.invalid;
  }
}
