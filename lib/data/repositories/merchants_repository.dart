import 'package:apate/data/models/merchants.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class MerchantsRepository {
  Future<Merchants?> getMerchants() async {
    final Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, "merchants");
      print("[MerchantsRepository] [getMerchants] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      print('[MerchantsRepository] [getMerchants] response $response');
      return Merchants.fromJson(response.data);
    } on DioError catch (e) {
      print('[MerchantsRepository] [getMerchants] exception: ${e.message}');
      throw e;
    }
  }
}
