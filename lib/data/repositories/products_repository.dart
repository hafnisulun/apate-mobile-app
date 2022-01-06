import 'package:apate/data/models/login.dart';
import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ProductsRepository {
  Dio _dio = Dio();
  LoginRepository _loginRepository = LoginRepository();
  String? _accessToken;

  Future<Products?> getProducts(String merchantUuid) async {
    _accessToken = await _loginRepository.getAccessToken();
    if (_accessToken == null) {
      print('[MerchantsRepository] [getProducts] accessToken null');
      return null;
    }

    try {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          var customHeaders = {'Authorization': 'Bearer ' + _accessToken!};
          options.headers.addAll(customHeaders);
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              Login? login = await _loginRepository.refreshToken();
              if (login != null) {
                _accessToken = login.accessToken.token;
                return handler.resolve(await _retry(error.requestOptions));
              }
            } catch (e) {
              print('[ProductsRepository] [getProducts] exception: $e');
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ));
      String url = join(API_BASE_URL, 'products?merchant_uuid=$merchantUuid');
      print('[ProductsRepository] [getProducts] url: $url');
      final response = await _dio.get(Uri.encodeFull(url));
      print('[ProductsRepository] [getProducts] response: $response');
      return Products.fromJson(response.data);
    } on DioError catch (e) {
      print('[ProductsRepository] [getProducts] exception: ${e.message}');
      throw e;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
