import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/address_repository.dart';
import 'package:apate/data/responses/addresses_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'addresses_event.dart';
part 'addresses_state.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final AddressRepository _addressRepository;

  AddressesBloc(this._addressRepository) : super(AddressesIdle()) {
    on<AddressesFetchEvent>(_onAddressesFetchEvent);
    on<AddressesDeleteEvent>(_onAddressesDeleteEvent);
  }

  @override
  void onTransition(Transition<AddressesEvent, AddressesState> transition) {
    print('[AddressesBloc] [onTransition] $transition');
    super.onTransition(transition);
  }

  void _onAddressesFetchEvent(
      AddressesFetchEvent event, Emitter<AddressesState> emit) async {
    emit(AddressesLoading());
    try {
      final AddressesResponse? address =
          await _addressRepository.getAddresses();
      if (address == null) {
        emit(AddressesFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(AddressesFetchSuccess(addresses: address.data));
      }
    } on DioError catch (e) {
      print('[AddressesBloc] [_onAddressesFetchEvent] exception response' +
          ' code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AddressesUnauthorized());
      } else {
        emit(AddressesFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }

  void _onAddressesDeleteEvent(
      AddressesDeleteEvent event, Emitter<AddressesState> emit) async {
    emit(AddressesLoading());
    try {
      final deleted = await _addressRepository.deleteAddress(event.address);
      if (!deleted) {
        emit(AddressesDeleteError(message: "Koneksi internet terputus"));
      } else {
        emit(AddressesDeleteSuccess(address: event.address));
      }
    } on DioError catch (e) {
      print('[AddressesBloc] [_onAddressesDeleteEvent] exception response' +
          ' code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AddressesUnauthorized());
      } else {
        emit(AddressesDeleteError(message: 'Koneksi internet terputus'));
      }
    }
  }
}
