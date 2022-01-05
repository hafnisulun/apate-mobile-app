import 'package:apate/data/models/cart_item.dart';
import 'package:apate/data/repositories/cart_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  final CartRepository _cartRepository;

  CartItemBloc(this._cartRepository) : super(CartItemFetchLoading()) {
    on<CartItemFetchEvent>(_onCartItemFetchEvent);
  }

  void _onCartItemFetchEvent(
      CartItemFetchEvent event, Emitter<CartItemState> emit) async {
    try {
      emit(CartItemFetchLoading());
      final item = await _cartRepository.getCartItem(event.productId);
      emit(CartItemFetchSuccess(item: item));
    } on DbException {
      emit(CartItemFetchError(message: "Terjadi kesalahan"));
    }
  }
}
