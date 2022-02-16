import 'package:apate/data/models/merchant.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class MerchantRepository {
  Future<Merchant?> getMerchant(String id) async {
    Dio dio = Dio();
    try {
      String idToken = 'abc123';
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {"Authorization": "Bearer " + idToken};
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
      String url = join(API_BASE_URL, "merchant", id);
      print("[MerchantRepository] [getMerchant] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      return Merchant.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

class NetworkException implements Exception {}
