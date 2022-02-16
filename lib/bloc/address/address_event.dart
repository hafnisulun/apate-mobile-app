part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressClustersFetchEvent extends AddressEvent {
  final Residence residence;

  const AddressClustersFetchEvent({
    required this.residence,
  });
}

class AddressSubmitEvent extends AddressEvent {}
