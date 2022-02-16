part of 'address_form_bloc.dart';

abstract class AddressFormEvent extends Equatable {
  const AddressFormEvent();

  @override
  List<Object> get props => [];
}

class AddressFormResidenceChangeEvent extends AddressFormEvent {
  final String residenceUuid;

  const AddressFormResidenceChangeEvent({
    required this.residenceUuid,
  });

  @override
  List<Object> get props => [residenceUuid];
}

class AddressFormClusterChangeEvent extends AddressFormEvent {
  final String clusterUuid;

  const AddressFormClusterChangeEvent({
    required this.clusterUuid,
  });

  @override
  List<Object> get props => [clusterUuid];
}

class AddressFormSubmitEvent extends AddressFormEvent {}
