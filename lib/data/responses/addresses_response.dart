import 'package:apate/data/models/address.dart';
import 'package:apate/data/models/meta.dart';

class AddressesResponse {
  List<Address> data;
  Meta meta;

  AddressesResponse({
    required this.data,
    required this.meta,
  });

  factory AddressesResponse.fromJson(Map<String, dynamic> json) {
    List<Address> data = new List.empty(growable: true);
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Address.fromJson(v));
      });
    }
    return AddressesResponse(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['meta'] = this.meta;
    map['data'] = this.data.map((v) => v.toJson()).toList();
    return map;
  }
}
