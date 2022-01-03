import 'package:apate/data/models/login.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class LoginRepository {
  Dio dio = Dio();

  Future<Login?> doLogin(String email, String password) async {
    try {
      print("[LoginRepository] [doLogin] email: $email");
      print("[LoginRepository] [doLogin] password: $password");
      String clientId = 'id123';
      String clientSecret = 'secret123';
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        var customHeaders = {
          "X-CLient-Id": clientId,
          "X-Client-Secret": clientSecret,
        };
        options.headers.addAll(customHeaders);
        return handler.next(options);
      }));
      String url = join(API_BASE_URL, "auth");
      print("[LoginRepository] [doLogin] url: $url");
      var data = {
        'grant_type': 'password',
        'email': email,
        'password': password,
      };
      final response = await dio.post(Uri.encodeFull(url), data: data);
      print("[LoginRepository] [doLogin] response: $response");
      var login = Login.fromJson(response.data);
      print("[LoginRepository] [doLogin] login: $login");
      return login;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        throw LoginException('Invalid email or password');
      }
      throw LoginException('Network error');
    }
  }
}

class LoginException implements Exception {
  final String message;

  LoginException(this.message);

  @override
  String toString() => message;
}
