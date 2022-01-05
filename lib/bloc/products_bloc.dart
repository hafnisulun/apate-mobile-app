import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _productsRepository;

  ProductsBloc(this._productsRepository) : super(ProductsFetchLoading()) {
    on<ProductsFetchEvent>(_onProductsFetchEvent);
  }

  void _onProductsFetchEvent(
      ProductsFetchEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsFetchLoading());
    try {
      final Products? products =
          await _productsRepository.getProducts(event.merchantUuid);
      if (products == null) {
        emit(ProductsFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(ProductsFetchSuccess(products: products));
      }
    } on Exception catch (e) {
      emit(ProductsFetchError(message: e.toString()));
    }
  }
}
