import 'package:apate/data/models/cluster.dart';

class Address {
  String uuid;
  String label;
  String residenceUuid;
  String clusterUuid;
  Cluster? cluster;
  String details;

  Address({
    required this.uuid,
    required this.label,
    required this.residenceUuid,
    required this.clusterUuid,
    required this.cluster,
    required this.details,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      uuid: json['uuid'],
      label: json['label'],
      residenceUuid: json['residence_uuid'],
      clusterUuid: json['cluster_uuid'],
      cluster: json['cluster'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['uuid'] = this.uuid;
    map['label'] = this.label;
    map['residence_uuid'] = this.residenceUuid;
    map['cluster_uuid'] = this.clusterUuid;
    map['cluster'] = this.cluster;
    map['details'] = this.details;
    return map;
  }
}
