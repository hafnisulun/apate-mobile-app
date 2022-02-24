part of 'address_form_bloc.dart';

abstract class AddressFormEvent extends Equatable {
  const AddressFormEvent();

  @override
  List<Object?> get props => [];
}

class AddressFormLabelChangeEvent extends AddressFormEvent {
  final String label;

  const AddressFormLabelChangeEvent({
    required this.label,
  });

  @override
  List<Object> get props => [label];
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
  final String? clusterUuid;

  const AddressFormClusterChangeEvent({
    this.clusterUuid,
  });

  @override
  List<Object?> get props => [clusterUuid];
}

class AddressFormDetailsChangeEvent extends AddressFormEvent {
  final String details;

  const AddressFormDetailsChangeEvent({
    required this.details,
  });

  @override
  List<Object> get props => [details];
}

class AddressFormSubmitEvent extends AddressFormEvent {
  final String? uuid;

  const AddressFormSubmitEvent({
    this.uuid,
  });

  List<Object?> get props => [uuid];
}

class AddressFormSubmitCreateEvent extends AddressFormEvent {}

class AddressFormSubmitUpdateEvent extends AddressFormEvent {
  final String uuid;

  const AddressFormSubmitUpdateEvent({
    required this.uuid,
  });

  @override
  List<Object> get props => [uuid];
}
