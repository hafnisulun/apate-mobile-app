part of 'address_form_bloc.dart';

class AddressFormState extends Equatable {
  final ResidenceInput residenceInput;
  final ClusterInput clusterInput;
  final FormzStatus status;
  final String message;

  const AddressFormState({
    this.residenceInput = const ResidenceInput.pure(),
    this.clusterInput = const ClusterInput.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
  });

  AddressFormState copyWith({
    ResidenceInput? residenceInput,
    ClusterInput? clusterInput,
    FormzStatus? status,
    String? message,
  }) {
    return AddressFormState(
      residenceInput: residenceInput ?? this.residenceInput,
      clusterInput: clusterInput ?? this.clusterInput,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [residenceInput, clusterInput, status, message];
}
