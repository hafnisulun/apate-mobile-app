import 'package:apate/data/models/cluster.dart';
import 'package:apate/data/models/meta.dart';

class ClustersResponse {
  List<Cluster> data;
  Meta? meta;

  ClustersResponse({
    required this.data,
    this.meta,
  });

  factory ClustersResponse.fromJson(Map<String, dynamic> json) {
    List<Cluster> data = new List.empty(growable: true);
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Cluster.fromJson(v));
      });
    }
    return ClustersResponse(
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['meta'] = this.meta;
    map['data'] = this.data.map((v) => v.toJson()).toList();
    return map;
  }
}
