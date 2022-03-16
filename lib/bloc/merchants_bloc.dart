import 'package:apate/data/models/merchants.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'merchants_event.dart';

part 'merchants_state.dart';

class MerchantsBloc extends Bloc<MerchantsEvent, MerchantsState> {
  final MerchantsRepository _merchantsRepository;

  MerchantsBloc(this._merchantsRepository) : super(MerchantsFetchIdle()) {
    on<MerchantsFetchEvent>(_onLoadMerchantsEvent);
  }

  void _onLoadMerchantsEvent(
      MerchantsFetchEvent event, Emitter<MerchantsState> emit) async {
    try {
      emit(MerchantsFetchLoading());
      final merchants =
          await _merchantsRepository.getMerchants(event.residenceUuid);
      if (merchants == null) {
        emit(
          MerchantsFetchError(
            residenceUuid: event.residenceUuid,
            message: "Koneksi internet terputus",
          ),
        );
      } else {
        emit(MerchantsFetchSuccess(merchants: merchants));
      }
    } on DioError catch (e) {
      print(
          '[MerchantsBloc] [_onLoadMerchantsEvent] exception response code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(MerchantsFetchUnauthorized());
      } else {
        emit(
          MerchantsFetchError(
            residenceUuid: event.residenceUuid,
            message: 'Koneksi internet terputus',
          ),
        );
      }
    }
  }
}
