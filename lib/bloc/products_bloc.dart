import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _productsRepository;

  ProductsBloc(this._productsRepository) : super(ProductsFetchLoading());

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    if (event is GetProductsEvent) {
      try {
        yield ProductsFetchLoading();
        final products =
            await _productsRepository.getProducts(event.merchantId);
        if (products == null) {
          yield ProductsFetchError(message: "Koneksi internet terputus");
        } else {
          yield ProductsFetchSuccess(products: products);
        }
      } on NetworkException {
        yield ProductsFetchError(message: "Koneksi internet terputus");
      }
    }
  }
}
