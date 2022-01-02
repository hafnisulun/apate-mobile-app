import 'package:apate/data/models/products.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductsRepository {
  Dio dio = Dio();

  Future<Products?> getProducts(String merchantId) async {
    try {
      String idToken = 'abc123';
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {"Authorization": "Bearer " + idToken};
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
      String url = join(API_BASE_URL, "products?merchantId=$merchantId");
      print("[ProductsRepository] [getProducts] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      return Products.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

class NetworkException implements Exception {}
