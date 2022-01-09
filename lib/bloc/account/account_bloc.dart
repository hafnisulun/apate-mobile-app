import 'package:apate/data/models/account.dart';
import 'package:apate/data/repositories/account_repository.dart';
import 'package:apate/data/responses/account_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;

  AccountBloc(this._accountRepository) : super(AccountFetchLoading()) {
    on<AccountFetchEvent>(_onAccountFetchEvent);
  }

  void _onAccountFetchEvent(
      AccountFetchEvent event, Emitter<AccountState> emit) async {
    emit(AccountFetchLoading());
    try {
      final AccountResponse? account = await _accountRepository.getAccount();
      print('[AccountBloc] [_onAccountFetchEvent] getAccount done');
      if (account == null) {
        emit(AccountFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(AccountFetchSuccess(account: account.data));
      }
    } on DioError catch (e) {
      print(
          '[AccountBloc] [_onAccountFetchEvent] exception response code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AccountFetchUnauthorized());
      } else {
        emit(AccountFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }
}
