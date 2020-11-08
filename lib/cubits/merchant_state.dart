part of 'merchant_cubit.dart';

abstract class MerchantState extends Equatable {
  const MerchantState();
}

class MerchantFetchLoading extends MerchantState {
  @override
  List<Object> get props => [];
}

class MerchantFetchSuccess extends MerchantState {
  final Merchant merchant;

  const MerchantFetchSuccess({this.merchant});

  @override
  List<Object> get props => [merchant];
}

class MerchantFetchError extends MerchantState {
  final String message;

  const MerchantFetchError({this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MerchantFetchError { message: $message }';
}
