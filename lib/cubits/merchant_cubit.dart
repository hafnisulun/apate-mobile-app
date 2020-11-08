import 'package:apate/data/models/merchant.dart';
import 'package:apate/data/repositories/merchant_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'merchant_state.dart';

class MerchantCubit extends Cubit<MerchantState> {
  final MerchantRepository _merchantRepository;

  MerchantCubit(
    this._merchantRepository,
  ) : super(MerchantFetchLoading());

  Future<void> getMerchant(String id) async {
    try {
      emit(MerchantFetchLoading());
      final merchant = await _merchantRepository.getMerchant(id);
      if (merchant == null) {
        emit(MerchantFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(MerchantFetchSuccess(merchant: merchant));
      }
    } on NetworkException {
      emit(MerchantFetchError(message: "Koneksi internet terputus"));
    }
  }
}
