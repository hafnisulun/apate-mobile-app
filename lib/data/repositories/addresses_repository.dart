import 'package:apate/data/responses/addresses_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class AddressesRepository {
  Future<AddressesResponse?> getAddresses() async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'users/me/addresses');
      print('[AddressRepository] [getAddresses] url: $url');
      final response = await dio.get(Uri.encodeFull(url));
      print('[AddressRepository] [getAddresses] response: $response');
      return AddressesResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[AddressRepository] [getAddresses] exception: ${e.message}');
      throw e;
    }
  }
}
