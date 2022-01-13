import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/addresses_repository.dart';
import 'package:apate/data/responses/addresses_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'addresses_event.dart';

part 'addresses_state.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final AddressesRepository _addressesRepository;

  AddressesBloc(this._addressesRepository) : super(AddressesFetchLoading()) {
    on<AddressesFetchEvent>(_onAddressFetchEvent);
  }

  void _onAddressFetchEvent(
      AddressesFetchEvent event, Emitter<AddressesState> emit) async {
    emit(AddressesFetchLoading());
    try {
      final AddressesResponse? address =
          await _addressesRepository.getAddresses();
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
