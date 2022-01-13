part of 'addresses_bloc.dart';

abstract class AddressesEvent extends Equatable {
  const AddressesEvent();

  @override
  List<Object> get props => [];
}

class AddressesFetchEvent extends AddressesEvent {
  AddressesFetchEvent();
}
