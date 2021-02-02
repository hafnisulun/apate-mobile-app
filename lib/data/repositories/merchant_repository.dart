import 'package:apate/data/models/merchant.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class MerchantRepository {
  Dio dio = Dio();

  Future<Merchant> getMerchant(String id) async {
    try {
      String idToken = await FirebaseAuth.instance.currentUser.getIdToken();
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var customHeaders = {"Authorization": "Bearer " + idToken};
        options.headers.addAll(customHeaders);
        return options;
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
