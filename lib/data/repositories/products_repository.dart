import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductsRepository {
  Dio dio = Dio();

  Future<Products?> getProducts(String merchantUuid) async {
    try {
      String? accessToken = await LoginRepository().getAccessToken();
      if (accessToken == null) {
        print('[MerchantsRepository] [getMerchants] accessToken null');
        return null;
      }
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {"Authorization": "Bearer " + accessToken};
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
      String url = join(API_BASE_URL, "products?merchant_uuid=$merchantUuid");
      print("[ProductsRepository] [getProducts] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      return Products.fromJson(response.data);
    } on DioError catch (_) {
      throw Exception('Koneksi internet terputus');
    }
  }
}
