import 'package:apate/data/models/cluster.dart';

class ClusterResponse {
  Cluster data;

  ClusterResponse({
    required this.data,
  });

  factory ClusterResponse.fromJson(Map<String, dynamic> json) {
    return ClusterResponse(
      data: Cluster.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['data'] = this.data;
    return map;
  }
}
