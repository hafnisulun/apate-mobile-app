import 'package:apate/data/models/cart_item.dart';
import 'package:apate/db_helper.dart';
import 'package:dio/dio.dart';

class CartRepository {
  Dio dio = Dio();
  final DbHelper _dbHelper = new DbHelper();

  Future<CartItem> getCartItem(String productId) async {
    return _dbHelper.getCartItem(productId);
  }
}

class DbException implements Exception {}
