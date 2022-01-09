part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();
}

class AccountFetchUnauthorized extends AccountState {
  @override
  List<Object> get props => [];
}

class AccountFetchLoading extends AccountState {
  @override
  List<Object> get props => [];
}

class AccountFetchSuccess extends AccountState {
  final Account account;

  const AccountFetchSuccess({required this.account});

  @override
  List<Object> get props => [account];
}

class AccountFetchError extends AccountState {
  final String message;

  const AccountFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AccountFetchError { message: $message }';
}
