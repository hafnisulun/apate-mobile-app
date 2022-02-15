class Residence {
  final String uuid;
  final String name;

  const Residence({
    required this.uuid,
    required this.name,
  });

  factory Residence.fromJson(Map<String, dynamic> json) {
    return Residence(
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
