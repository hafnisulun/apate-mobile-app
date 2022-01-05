part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsFetchEvent extends ProductsEvent {
  final String merchantUuid;

  ProductsFetchEvent(this.merchantUuid);
}
