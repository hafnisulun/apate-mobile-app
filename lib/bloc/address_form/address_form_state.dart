part of 'address_form_bloc.dart';

class AddressFormState extends Equatable {
  final AddressLabelInput labelInput;
  final ResidenceInput residenceInput;
  final ClusterInput clusterInput;
  final AddressDetailInput detailInput;
  final FormzStatus status;
  final String message;

  const AddressFormState({
    this.labelInput = const AddressLabelInput.pure(),
    this.residenceInput = const ResidenceInput.pure(),
    this.clusterInput = const ClusterInput.pure(),
    this.detailInput = const AddressDetailInput.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
  });

  AddressFormState copyWith({
    AddressLabelInput? labelInput,
    ResidenceInput? residenceInput,
    ClusterInput? clusterInput,
    AddressDetailInput? detailInput,
    FormzStatus? status,
    String? message,
  }) {
    return AddressFormState(
      labelInput: labelInput ?? this.labelInput,
      residenceInput: residenceInput ?? this.residenceInput,
      clusterInput: clusterInput ?? this.clusterInput,
      detailInput: detailInput ?? this.detailInput,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        labelInput,
        residenceInput,
        clusterInput,
        detailInput,
        status,
        message,
      ];
}
