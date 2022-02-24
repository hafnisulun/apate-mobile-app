part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();
}

class AddressIdle extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressResidenceFetchUnauthorized extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressResidenceFetchLoading extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressResidenceFetchSuccess extends AddressState {
  final Residence residence;

  const AddressResidenceFetchSuccess({required this.residence});

  @override
  List<Object?> get props => [residence];
}

class AddressResidenceFetchError extends AddressState {
  final String message;

  const AddressResidenceFetchError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AddressResidenceFetchError { message: $message }';
}

class AddressClusterFetch extends AddressState {
  final Residence residence;

  AddressClusterFetch({
    required this.residence,
  });

  @override
  List<Object?> get props => [residence];
}

class AddressClusterFetchUnauthorized extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressClusterFetchLoading extends AddressClusterFetch {
  final Residence residence;

  AddressClusterFetchLoading({required this.residence})
      : super(residence: residence);

  @override
  List<Object?> get props => [residence];
}

class AddressClusterFetchSuccess extends AddressClusterFetch {
  final Residence residence;
  final Cluster cluster;

  AddressClusterFetchSuccess({
    required this.residence,
    required this.cluster,
  }) : super(residence: residence);

  @override
  List<Object?> get props => [residence, cluster];
}

class AddressClusterFetchError extends AddressClusterFetch {
  final Residence residence;
  final String message;

  AddressClusterFetchError({
    required this.residence,
    required this.message,
  }) : super(residence: residence);

  @override
  List<Object?> get props => [residence, message];

  @override
  String toString() => 'AddressClusterFetchError { message: $message }';
}

class AddressClustersFetchLoading extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressClustersFetchSuccess extends AddressState {
  final List<Cluster> clusters;

  const AddressClustersFetchSuccess({required this.clusters});

  @override
  List<Object?> get props => [clusters];
}

class AddressClustersFetchError extends AddressState {
  final String message;

  const AddressClustersFetchError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AddressClustersFetchError { message: $message }';
}

class AddressClustersFetchUnauthorized extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressResidenceChangeSuccess extends AddressState {
  final Residence residence;

  const AddressResidenceChangeSuccess({required this.residence});

  @override
  List<Object?> get props => [residence];
}
