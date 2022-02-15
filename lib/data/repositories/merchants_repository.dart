import 'package:apate/data/models/merchants.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class MerchantsRepository {
  final Dio _dio = Dio();
  final LoginRepository _loginRepository = LoginRepository();

  Future<Merchants?> getMerchants() async {
    try {
      String? accessToken = await _loginRepository.getAccessToken();
      if (accessToken == null) {
        print('[MerchantsRepository] [getMerchants] accessToken null');
        return null;
      }
      _dio.interceptors.add(Auth.getDioInterceptorsWrapper(_dio));
      String url = join(API_BASE_URL, "merchants");
      print("[MerchantsRepository] [getMerchants] url: $url");
      final response = await _dio.get(Uri.encodeFull(url));
      print('[MerchantsRepository] [getMerchants] response $response');
      return Merchants.fromJson(response.data);
    } on DioError catch (e) {
      print('[MerchantsRepository] [getMerchants] exception: ${e.message}');
      throw e;
    }
  }
}
