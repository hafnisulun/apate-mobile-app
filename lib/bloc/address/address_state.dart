part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();
}

class AddressIdle extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressResidenceFetchUnauthorized extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressResidenceFetchIdle extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressResidenceFetchLoading extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressResidenceFetchSuccess extends AddressState {
  final Residence residence;

  const AddressResidenceFetchSuccess({required this.residence});

  @override
  List<Object> get props => [residence];
}

class AddressResidenceFetchError extends AddressState {
  final String message;

  const AddressResidenceFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddressResidenceFetchError { message: $message }';
}

class AddressClusterFetchUnauthorized extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressClusterFetchIdle extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressClusterFetchLoading extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressClusterFetchSuccess extends AddressState {
  final Residence residence;
  final Cluster cluster;

  const AddressClusterFetchSuccess({
    required this.residence,
    required this.cluster,
  });

  @override
  List<Object> get props => [cluster];
}

class AddressClusterFetchError extends AddressState {
  final String message;

  const AddressClusterFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddressClusterFetchError { message: $message }';
}

class AddressClustersFetchLoading extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressClustersFetchSuccess extends AddressState {
  final List<Cluster> clusters;

  const AddressClustersFetchSuccess({required this.clusters});

  @override
  List<Object> get props => [clusters];
}

class AddressClustersFetchError extends AddressState {
  final String message;

  const AddressClustersFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddressClustersFetchError { message: $message }';
}

class AddressClustersFetchUnauthorized extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressResidenceChangeSuccess extends AddressState {
  final Residence residence;

  const AddressResidenceChangeSuccess({required this.residence});

  @override
  List<Object> get props => [residence];
}
