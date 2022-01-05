part of 'cart_item_bloc.dart';

abstract class CartItemEvent extends Equatable {
  const CartItemEvent();

  @override
  List<Object> get props => [];
}

class CartItemFetchEvent extends CartItemEvent {
  final String productId;

  CartItemFetchEvent(this.productId);
}
