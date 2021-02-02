import 'package:apate/data/models/product.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductRepository {
  Dio dio = Dio();

  Future<Product> getProduct(String id) async {
    try {
      String idToken = await FirebaseAuth.instance.currentUser.getIdToken();
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var customHeaders = {"Authorization": "Bearer " + idToken};
        options.headers.addAll(customHeaders);
        return options;
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
