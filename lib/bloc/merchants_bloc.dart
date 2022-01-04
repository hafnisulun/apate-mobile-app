import 'package:apate/data/models/merchants.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'merchants_event.dart';
part 'merchants_state.dart';

class MerchantsBloc extends Bloc<MerchantsEvent, MerchantsState> {
  final MerchantsRepository _merchantsRepository;

  MerchantsBloc(this._merchantsRepository) : super(MerchantsFetchLoading()) {
    on<LoadMerchantsEvent>(_onLoadMerchantsEvent);
  }

  void _onLoadMerchantsEvent(
      LoadMerchantsEvent event, Emitter<MerchantsState> emit) async {
    try {
      emit(MerchantsFetchLoading());
      final merchants = await _merchantsRepository.getMerchants();
      if (merchants == null) {
        emit(MerchantsFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(MerchantsFetchSuccess(merchants: merchants));
      }
    } on Exception catch (e) {
      emit(MerchantsFetchError(message: e.toString()));
    }
  }
}
