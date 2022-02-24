part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class AddressResidenceFetchEvent extends AddressEvent {
  final String residenceUuid;

  const AddressResidenceFetchEvent({
    required this.residenceUuid,
  });

  @override
  List<Object?> get props => [residenceUuid];
}

class AddressResidenceChangeEvent extends AddressEvent {
  final Residence residence;

  const AddressResidenceChangeEvent({
    required this.residence,
  });

  @override
  List<Object?> get props => [residence];
}

class AddressClusterFetchEvent extends AddressEvent {
  final Residence residence;
  final String clusterUuid;

  const AddressClusterFetchEvent({
    required this.residence,
    required this.clusterUuid,
  });

  @override
  List<Object?> get props => [residence, clusterUuid];
}

class AddressClustersFetchEvent extends AddressEvent {
  final Residence residence;

  const AddressClustersFetchEvent({
    required this.residence,
  });

  @override
  List<Object?> get props => [residence];
}

class AddressSubmitEvent extends AddressEvent {}
