class Account {
  String uuid;
  String email;
  String name;
  String phone;
  String gender;

  Account({
    required this.uuid,
    required this.email,
    required this.name,
    required this.phone,
    required this.gender,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      uuid: json['uuid'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['uuid'] = this.uuid;
    map['email'] = this.email;
    map['name'] = this.name;
    map['phone'] = this.phone;
    map['gender'] = this.gender;
    return map;
  }
}
