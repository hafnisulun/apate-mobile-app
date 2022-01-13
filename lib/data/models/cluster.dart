class Cluster {
  String uuid;
  String name;

  Cluster({
    required this.uuid,
    required this.name,
  });

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      uuid: json['uuid'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['uuid'] = this.uuid;
    map['name'] = this.name;
    return map;
  }
}
