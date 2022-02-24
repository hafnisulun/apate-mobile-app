import 'package:apate/data/models/address.dart';

class AddressResponse {
  Address data;

  AddressResponse({
    required this.data,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      data: Address.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['data'] = this.data;
    return map;
  }
}
