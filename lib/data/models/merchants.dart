import 'package:apate/data/models/merchant.dart';
import 'package:apate/data/models/meta.dart';

class Merchants {
  List<Merchant> data;
  Meta meta;

  Merchants({
    required this.data,
    required this.meta,
  });

  factory Merchants.fromJson(Map<String, dynamic> json) {
    List<Merchant> data = new List.empty(growable: true);
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(new Merchant.fromJson(v));
      });
    }
    Merchants merchants =
        Merchants(data: data, meta: new Meta.fromJson(json['meta']));
    return merchants;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['meta'] = this.meta;
    map['data'] = this.data.map((v) => v.toJson()).toList();
    return map;
  }
}
