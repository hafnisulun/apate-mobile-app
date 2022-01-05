import 'package:apate/data/models/merchants.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class MerchantsRepository {
  final Dio dio = Dio();
  final LoginRepository _loginRepository = LoginRepository();

  Future<Merchants?> getMerchants() async {
    try {
      String? accessToken = await _loginRepository.getAccessToken();
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
      String url = join(API_BASE_URL, "merchants");
      print("[MerchantsRepository] [getMerchants] url: $url");
      final response = await dio.get(Uri.encodeFull(url));
      print('[MerchantsRepository] [getMerchants] response $response');
      return Merchants.fromJson(response.data);
    } on DioError catch (_) {
      throw Exception('Koneksi internet terputus');
    }
  }
}
