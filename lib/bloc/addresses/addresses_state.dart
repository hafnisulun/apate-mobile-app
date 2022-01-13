part of 'addresses_bloc.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();
}

class AddressesFetchUnauthorized extends AddressesState {
  @override
  List<Object> get props => [];
}

class AddressesFetchLoading extends AddressesState {
  @override
  List<Object> get props => [];
}

class AddressesFetchSuccess extends AddressesState {
  final List<Address> addresses;

  const AddressesFetchSuccess({required this.addresses});

  @override
  List<Object> get props => [addresses];
}

class AddressesFetchError extends AddressesState {
  final String message;

  const AddressesFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddressFetchError { message: $message }';
}
