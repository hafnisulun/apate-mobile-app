import 'package:apate/data/responses/account_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class AccountRepository {
  Future<AccountResponse?> getAccount() async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'users', 'me');
      print('[AccountRepository] [getAccount] url: $url');
      final response = await dio.get(Uri.encodeFull(url));
      print('[AccountRepository] [getAccount] response: $response');
      return AccountResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[AccountRepository] [getAccount] exception: ${e.message}');
      throw e;
    }
  }
}
