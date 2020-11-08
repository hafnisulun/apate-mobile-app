import 'package:apate/data/models/merchants.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class MerchantsRepository {
  Dio dio = Dio();

  Future<Merchants> getMerchants() async {
    try {
      String url = join(API_BASE_URL, "merchants");
      print("[MerchantsRepository] [getMerchants] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      return Merchants.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

class NetworkException implements Exception {}
