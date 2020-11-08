import 'package:apate/data/models/merchants.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'merchants_state.dart';

class MerchantsCubit extends Cubit<MerchantsState> {
  final MerchantsRepository _merchantsRepository;

  MerchantsCubit(
    this._merchantsRepository,
  ) : super(MerchantsFetchLoading());

  Future<void> getMerchants() async {
    try {
      emit(MerchantsFetchLoading());
      final merchants = await _merchantsRepository.getMerchants();
      if (merchants == null) {
        emit(MerchantsFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(MerchantsFetchSuccess(merchants: merchants));
      }
    } on NetworkException {
      emit(MerchantsFetchError(message: "Koneksi internet terputus"));
    }
  }
}
