part of 'addresses_bloc.dart';

abstract class AddressesEvent extends Equatable {
  const AddressesEvent();

  @override
  List<Object?> get props => [];
}

class AddressesFetchEvent extends AddressesEvent {
  AddressesFetchEvent();
}

class AddressesDeleteEvent extends AddressesEvent {
  final Address address;

  AddressesDeleteEvent({required this.address});

  @override
  List<Object?> get props => [address];
}
