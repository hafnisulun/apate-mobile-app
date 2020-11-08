part of 'cart_item_cubit.dart';

abstract class CartItemState extends Equatable {
  const CartItemState();
}

class CartItemFetchLoading extends CartItemState {
  @override
  List<Object> get props => [];
}

class CartItemFetchSuccess extends CartItemState {
  final CartItem item;

  const CartItemFetchSuccess({this.item});

  @override
  List<Object> get props => [item];
}

class CartItemFetchError extends CartItemState {
  final String message;

  const CartItemFetchError({this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CartItemFetchError { message: $message }';
}
