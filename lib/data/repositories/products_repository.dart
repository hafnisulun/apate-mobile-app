import 'package:apate/data/models/products.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductsRepository {
  Dio _dio = Dio();

  Future<Products?> getProducts(String merchantUuid) async {
    try {
      _dio.interceptors.add(Auth.getDioInterceptorsWrapper(_dio));
      String url = join(API_BASE_URL, 'products?merchant_uuid=$merchantUuid');
      print('[ProductsRepository] [getProducts] url: $url');
      final response = await _dio.get(Uri.encodeFull(url));
      print('[ProductsRepository] [getProducts] response: $response');
      return Products.fromJson(response.data);
    } on DioError catch (e) {
      print('[ProductsRepository] [getProducts] exception: ${e.message}');
      throw e;
    }
  }
}
