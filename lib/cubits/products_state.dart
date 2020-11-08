part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsFetchLoading extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductsFetchSuccess extends ProductsState {
  final Products products;

  const ProductsFetchSuccess({this.products});

  @override
  List<Object> get props => [products];
}

class ProductsFetchError extends ProductsState {
  final String message;

  const ProductsFetchError({this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ProductsFetchError { message: $message }';
}
