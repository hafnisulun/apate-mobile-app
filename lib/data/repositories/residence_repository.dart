import 'package:apate/data/responses/residence_response.dart';
import 'package:apate/data/responses/residences_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ResidenceRepository {
  Future<ResidencesResponse?> getResidences() async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'residences');
      print('[ResidencesRepository] [getResidences] url: $url');
      final response = await dio.get(Uri.encodeFull(url));
      print('[ResidencesRepository] [getResidences] response: $response');
      return ResidencesResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[ResidencesRepository] [getResidences] exception: ${e.message}');
      throw e;
    }
  }

  Future<ResidenceResponse?> getResidence(String residenceUuid) async {
    Dio dio = Dio();
    try {
      dio.interceptors.add(Auth.getDioInterceptorsWrapper(dio));
      String url = join(API_BASE_URL, 'residences', residenceUuid);
      print('[ResidenceRepository] [getResidence] url: $url');
      final response = await dio.get(Uri.encodeFull(url));
      print('[ResidenceRepository] [getResidence] response: $response');
      return ResidenceResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[ResidenceRepository] [getResidence] exception: ${e.message}');
      throw e;
    }
  }
}
