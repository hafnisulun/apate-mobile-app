import 'dart:convert';

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

  Future<AccountResponse?> createAccount(
    String email,
    String password,
    String name,
  ) async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            var credentials = "$API_CLIENT_ID:$API_CLIENT_SECRET";
            Codec<String, String> stringToBase64 = utf8.fuse(base64);
            var customHeaders = {
              'Authorization': 'Basic ' + stringToBase64.encode(credentials)
            };
            options.headers.addAll(customHeaders);
            return handler.next(options);
          },
        ),
      );
      String url = join(API_BASE_URL, "users");
      print("[AccountRepository] [createAccount] url: $url");
      var data = {
        'email': email,
        'password': password,
        'name': name,
      };
      final response = await dio.post(Uri.encodeFull(url), data: data);
      print("[AccountRepository] [createAccount] response: $response");
      return AccountResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw e;
    }
  }
}
