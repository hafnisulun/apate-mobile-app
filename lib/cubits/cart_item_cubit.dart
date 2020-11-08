import 'package:apate/data/models/cart_item.dart';
import 'package:apate/data/repositories/cart_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_item_state.dart';

class CartItemCubit extends Cubit<CartItemState> {
  final CartRepository _cartRepository;

  CartItemCubit(
    this._cartRepository,
  ) : super(CartItemFetchLoading());

  Future<void> getCartItem(String productId) async {
    try {
      emit(CartItemFetchLoading());
      final item = await _cartRepository.getCartItem(productId);
      emit(CartItemFetchSuccess(item: item));
    } on DbException {
      emit(CartItemFetchError(message: "Terjadi kesalahan"));
    }
  }
}
