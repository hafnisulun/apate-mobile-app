part of 'address_form_bloc.dart';

abstract class AddressFormEvent extends Equatable {
  const AddressFormEvent();

  @override
  List<Object> get props => [];
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
  final String clusterUuid;

  const AddressFormClusterChangeEvent({
    required this.clusterUuid,
  });

  @override
  List<Object> get props => [clusterUuid];
}

class AddressFormDetailChangeEvent extends AddressFormEvent {
  final String detail;

  const AddressFormDetailChangeEvent({
    required this.detail,
  });

  @override
  List<Object> get props => [detail];
}

class AddressFormSubmitEvent extends AddressFormEvent {}
