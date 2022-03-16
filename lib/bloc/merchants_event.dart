part of 'merchants_bloc.dart';

abstract class MerchantsEvent extends Equatable {
  const MerchantsEvent();

  @override
  List<Object> get props => [];
}

class MerchantsFetchEvent extends MerchantsEvent {
  final String residenceUuid;

  MerchantsFetchEvent(this.residenceUuid);

  @override
  List<Object> get props => [residenceUuid];
}
