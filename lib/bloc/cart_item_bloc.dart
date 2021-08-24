import 'package:apate/data/models/cart_item.dart';
import 'package:apate/data/repositories/cart_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  final CartRepository _cartRepository;

  CartItemBloc(this._cartRepository) : super(CartItemFetchLoading());

  @override
  Stream<CartItemState> mapEventToState(CartItemEvent event) async* {
    if (event is GetCartItemEvent) {
      try {
        yield CartItemFetchLoading();
        final item = await _cartRepository.getCartItem(event.productId);
        yield CartItemFetchSuccess(item: item);
      } on DbException {
        yield CartItemFetchError(message: "Terjadi kesalahan");
      }
    }
  }
}
