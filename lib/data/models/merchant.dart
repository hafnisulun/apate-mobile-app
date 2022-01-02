class Merchant {
  String id;
  String name;
  String address;
  String? phone;
  String? image;

  Merchant({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.image,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['address'] = this.address;
    map['phone'] = this.phone;
    map['image'] = this.image;
    return map;
  }
}
