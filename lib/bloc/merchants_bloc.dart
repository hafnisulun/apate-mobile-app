import 'package:apate/data/models/merchants.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'merchants_event.dart';

part 'merchants_state.dart';

class MerchantsBloc extends Bloc<MerchantsEvent, MerchantsState> {
  final MerchantsRepository _merchantsRepository;

  MerchantsBloc(this._merchantsRepository) : super(MerchantsFetchLoading());

  @override
  Stream<MerchantsState> mapEventToState(MerchantsEvent event) async* {
    if (event is LoadMerchantsEvent) {
      try {
        yield MerchantsFetchLoading();
        final merchants = await _merchantsRepository.getMerchants();
        if (merchants == null) {
          yield MerchantsFetchError(message: "Koneksi internet terputus");
        } else {
          yield MerchantsFetchSuccess(merchants: merchants);
        }
      } on NetworkException {
        yield MerchantsFetchError(message: "Koneksi internet terputus");
      }
    }
  }
}
