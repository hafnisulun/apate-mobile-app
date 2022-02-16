import 'package:apate/data/responses/residences_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ResidencesRepository {
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
}
