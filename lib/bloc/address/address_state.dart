part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();
}

class AddressIdle extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressClustersFetchLoading extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressClustersFetchSuccess extends AddressState {
  final List<Cluster> clusters;

  const AddressClustersFetchSuccess({required this.clusters});

  @override
  List<Object> get props => [];
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
