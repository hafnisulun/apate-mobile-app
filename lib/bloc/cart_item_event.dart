part of 'cart_item_bloc.dart';

abstract class CartItemEvent extends Equatable {
  const CartItemEvent();

  @override
  List<Object> get props => [];
}

class GetCartItemEvent extends CartItemEvent {
  final String productId;

  GetCartItemEvent(this.productId);
}
