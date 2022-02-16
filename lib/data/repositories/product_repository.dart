import 'package:apate/data/models/product.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductRepository {
  Future<Product?> getProduct(String id) async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, "product", id);
      print("[ProductRepository] [getProduct] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      return Product.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

class NetworkException implements Exception {}
