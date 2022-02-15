import 'package:apate/data/responses/residences_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ResidencesRepository {
  Dio _dio = Dio();

  Future<ResidencesResponse?> getResidences() async {
    try {
      _dio.interceptors.add(Auth.getDioInterceptorsWrapper(_dio));
      String url = join(API_BASE_URL, 'residences');
      print('[ResidencesRepository] [getResidences] url: $url');
      final response = await _dio.get(Uri.encodeFull(url));
      print('[ResidencesRepository] [getResidences] response: $response');
      return ResidencesResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[ResidencesRepository] [getResidences] exception: ${e.message}');
      throw e;
    }
  }
}
