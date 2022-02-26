part of 'addresses_bloc.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();
}

class AddressesIdle extends AddressesState {
  @override
  List<Object?> get props => [];
}

class AddressesLoading extends AddressesState {
  @override
  List<Object?> get props => [];
}

class AddressesUnauthorized extends AddressesState {
  @override
  List<Object?> get props => [];
}

class AddressesFetchSuccess extends AddressesState {
  final List<Address> addresses;

  const AddressesFetchSuccess({required this.addresses});

  @override
  List<Object?> get props => [addresses];
}

class AddressesFetchError extends AddressesState {
  final String message;

  const AddressesFetchError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AddressFetchError { message: $message }';
}

class AddressesDeleteSuccess extends AddressesState {
  final Address address;

  AddressesDeleteSuccess({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressesDeleteError extends AddressesState {
  final String message;

  const AddressesDeleteError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AddressesDeleteError { message: $message }';
}
