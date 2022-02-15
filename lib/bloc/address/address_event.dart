part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressResidenceChangeEvent extends AddressEvent {
  const AddressResidenceChangeEvent({
    required this.residence,
    required this.residenceInput,
  });

  final Residence residence;
  final String residenceInput;

  @override
  List<Object> get props => [residence];
}

class AddressSubmitEvent extends AddressEvent {}
