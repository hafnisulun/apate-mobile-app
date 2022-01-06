import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
      print('[ProductsBloc] [_onProductsFetchEvent] getProducts done');
      if (products == null) {
        emit(ProductsFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(ProductsFetchSuccess(products: products));
      }
    } on DioError catch (e) {
      print(
          '[ProductsBloc] [_onProductsFetchEvent] exception response code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(ProductsFetchUnauthorized());
      } else {
        emit(ProductsFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }
}
