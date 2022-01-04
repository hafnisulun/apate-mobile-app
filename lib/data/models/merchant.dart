class Merchant {
  String uuid;
  String name;
  double lat;
  double lon;
  String? phone;
  String? image;

  Merchant({
    required this.uuid,
    required this.name,
    required this.lat,
    required this.lon,
    this.phone,
    this.image,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      uuid: json['uuid'],
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['uuid'] = this.uuid;
    map['name'] = this.name;
    map['lat'] = this.lat;
    map['lon'] = this.lon;
    map['phone'] = this.phone;
    map['image'] = this.image;
    return map;
  }
}
