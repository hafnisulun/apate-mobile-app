import 'package:apate/data/responses/cluster_response.dart';
import 'package:apate/data/responses/clusters_response.dart';
import 'package:apate/utils/auth.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class ClusterRepository {
  Dio _dio = Dio();

  Future<ClusterResponse?> getCluster(
      String residenceUuid, String clusterUuid) async {
    try {
      _dio.interceptors.add(Auth.getDioInterceptorsWrapper(_dio));
      String url = join(
          API_BASE_URL, 'residences', residenceUuid, 'clusters', clusterUuid);
      print('[ClusterRepository] [getCluster] url: $url');
      final response = await _dio.get(Uri.encodeFull(url));
      print('[ClusterRepository] [getCluster] response: $response');
      return ClusterResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[ClusterRepository] [getCluster] exception: ${e.message}');
      throw e;
    }
  }

  Future<ClustersResponse?> getClusters(String residenceUuid) async {
    try {
      _dio.interceptors.add(Auth.getDioInterceptorsWrapper(_dio));
      String url = join(API_BASE_URL, 'residences', residenceUuid);
      print('[ClusterRepository] [getClusters] url: $url');
      final response = await _dio.get(Uri.encodeFull(url));
      print('[ClusterRepository] [getClusters] response: $response');
      return ClustersResponse.fromJson(response.data);
    } on DioError catch (e) {
      print('[ClusterRepository] [getClusters] exception: ${e.message}');
      throw e;
    }
  }
}
