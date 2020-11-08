part of 'merchants_cubit.dart';

abstract class MerchantsState extends Equatable {
  const MerchantsState();
}

class MerchantsFetchLoading extends MerchantsState {
  @override
  List<Object> get props => [];
}

class MerchantsFetchSuccess extends MerchantsState {
  final Merchants merchants;

  const MerchantsFetchSuccess({this.merchants});

  @override
  List<Object> get props => [merchants];
}

class MerchantsFetchError extends MerchantsState {
  final String message;

  const MerchantsFetchError({this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MerchantsFetchError { message: $message }';
}
