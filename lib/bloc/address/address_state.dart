part of 'address_bloc.dart';

class AddressState extends Equatable {
  const AddressState({
    this.residence = const Residence(name: '', uuid: ''),
    this.residenceInput = const ResidenceInput.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
  });

  final Residence residence;
  final ResidenceInput residenceInput;
  final FormzStatus status;
  final String message;

  AddressState copyWith({
    Residence? residence,
    ResidenceInput? residenceInput,
    FormzStatus? status,
    String? message,
  }) {
    return AddressState(
      residence: residence ?? this.residence,
      residenceInput: residenceInput ?? this.residenceInput,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [residence, residenceInput, status, message];
}
