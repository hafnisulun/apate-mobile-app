import 'package:apate/data/models/address.dart';
import 'package:apate/data/responses/address_response.dart';
import 'package:apate/data/responses/addresses_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class AddressRepository {
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

  Future<AddressResponse?> createAddress(Address address) async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'users/me/addresses');
      print('[AddressRepository] [createAddress] url: $url');
      final response = await dio.post(Uri.encodeFull(url), data: address);
      print('[AddressRepository] [createAddress] response: $response');
      return AddressResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[AddressRepository] [createAddress] exception: ${e.message}');
      throw e;
    }
  }

  Future<AddressResponse?> updateAddress(Address address) async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'users/me/addresses', address.uuid);
      print('[AddressRepository] [updateAddress] url: $url');
      final response = await dio.put(Uri.encodeFull(url), data: address);
      print('[AddressRepository] [updateAddress] response: $response');
      return AddressResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[AddressRepository] [updateAddress] exception: ${e.message}');
      throw e;
    }
  }

  Future<bool> deleteAddress(Address address) async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'users/me/addresses', address.uuid);
      print('[AddressRepository] [deleteAddress] url: $url');
      final response = await dio.delete(Uri.encodeFull(url));
      print('[AddressRepository] [deleteAddress] response code: ' +
          '${response.statusCode}');
      if (response.statusCode == 204) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      print('[AddressRepository] [deleteAddress] exception: ${e.message}');
      throw e;
    }
  }
}
