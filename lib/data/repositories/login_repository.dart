import 'package:apate/data/models/email.dart';
import 'package:apate/data/models/login.dart';
import 'package:apate/data/models/password.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class LoginRepository {
  Dio _dio = Dio();
  FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Login?> doLogin(Email email, Password password) async {
    try {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {
          "X-CLient-Id": API_CLIENT_ID,
          "X-Client-Secret": API_CLIENT_SECRET,
        };
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
      String url = join(API_BASE_URL, "auth");
      print("[LoginRepository] [doLogin] url: $url");
      var data = {
        'grant_type': 'password',
        'email': email.value,
        'password': password.value,
      };
      final response = await _dio.post(Uri.encodeFull(url), data: data);
      print("[LoginRepository] [doLogin] response: $response");
      var login = Login.fromJson(response.data);
      _saveTokens(login.accessToken.token, login.refreshToken.token);
      return login;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<Login?> refreshToken() async {
    try {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {
          "X-CLient-Id": API_CLIENT_ID,
          "X-Client-Secret": API_CLIENT_SECRET
        };
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
      String url = join(API_BASE_URL, "auth");
      print("[LoginRepository] [refreshToken] url: $url");
      var data = {
        'grant_type': 'refresh_token',
        'refresh_token': await getRefreshToken(),
      };
      final response = await _dio.post(Uri.encodeFull(url), data: data);
      print("[LoginRepository] [refreshToken] response: $response");
      var login = Login.fromJson(response.data);
      _saveTokens(login.accessToken.token, login.refreshToken.token);
      return login;
    } on DioError catch (e) {
      print('[LoginRepository] [refreshToken] exception: ' + e.message);
      if (e.response!.statusCode == 401) {
        throw Exception('Refresh token invalid');
      }
      throw Exception('Koneksi internet terputus');
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  void _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }
}
