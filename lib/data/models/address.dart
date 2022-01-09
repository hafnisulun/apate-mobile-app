class Address {
  String uuid;
  String label;
  String clusterUuid;
  String details;

  Address({
    required this.uuid,
    required this.label,
    required this.clusterUuid,
    required this.details,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      uuid: json['uuid'],
      label: json['label'],
      clusterUuid: json['clusterUuid'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['uuid'] = this.uuid;
    map['label'] = this.label;
    map['clusterUuid'] = this.clusterUuid;
    map['details'] = this.details;
    return map;
  }
}
