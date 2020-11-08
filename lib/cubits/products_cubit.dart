import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _productsRepository;

  ProductsCubit(
    this._productsRepository,
  ) : super(ProductsFetchLoading());

  Future<void> getProducts(String merchantId) async {
    try {
      emit(ProductsFetchLoading());
      final products = await _productsRepository.getProducts(merchantId);
      if (products == null) {
        emit(ProductsFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(ProductsFetchSuccess(products: products));
      }
    } on NetworkException {
      emit(ProductsFetchError(message: "Koneksi internet terputus"));
    }
  }
}
