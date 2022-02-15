import 'package:apate/data/models/login.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  static Future<bool> isLoggedIn() async {
    String? accessToken = await LoginRepository().getAccessToken();
    return accessToken != null;
  }

  static void logOut(BuildContext context) {
    _clearStorage();
    goToLogInPage(context);
  }

  static void goToLogInPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),
      (_) => false,
    );
  }

  static InterceptorsWrapper getDioInterceptorsWrapper(Dio dio) {
    LoginRepository loginRepository = LoginRepository();
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await loginRepository.getAccessToken();
        if (accessToken != null) {
          var customHeaders = {'Authorization': 'Bearer ' + accessToken};
          options.headers.addAll(customHeaders);
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            Login? login = await loginRepository.refreshToken();
            if (login != null) {
              return handler
                  .resolve(await _dioRetry(dio, error.requestOptions));
            }
          } catch (e) {
            print('[Auth] [getDioInterceptorsWrapper] exception: $e');
            _clearStorage();
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    );
  }

  static void _clearStorage() {
    FlutterSecureStorage().deleteAll();
  }

  static Future<Response<dynamic>> _dioRetry(
      Dio dio, RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
