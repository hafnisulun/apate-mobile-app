import 'package:apate/data/models/login.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Auth {
  static void logout(BuildContext context) async {
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
            print('[ProductsRepository] [getProducts] exception: $e');
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    );
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
