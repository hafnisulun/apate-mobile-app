import 'package:apate/data/models/product.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductRepository {
  Dio dio = Dio();

  Future<Product?> getProduct(String id) async {
    try {
      String idToken = 'abc123';
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {"Authorization": "Bearer " + idToken};
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
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
