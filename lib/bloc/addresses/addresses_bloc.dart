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

  AddressesBloc(this._addressRepository) : super(AddressesFetchLoading()) {
    on<AddressesFetchEvent>(_onAddressesFetchEvent);
  }

  void _onAddressesFetchEvent(
      AddressesFetchEvent event, Emitter<AddressesState> emit) async {
    emit(AddressesFetchLoading());
    try {
      final AddressesResponse? address =
          await _addressRepository.getAddresses();
      print('[AddressesBloc] [_onAddressesesFetchEvent] getAddress done');
      if (address == null) {
        emit(AddressesFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(AddressesFetchSuccess(addresses: address.data));
      }
    } on DioError catch (e) {
      print(
          '[AddressesBloc] [_onAddressesFetchEvent] exception response code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AddressesFetchUnauthorized());
      } else {
        emit(AddressesFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }
}
