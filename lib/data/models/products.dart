import 'package:apate/data/models/meta.dart';
import 'package:apate/data/models/product.dart';

class Products {
  List<Product> data;
  Meta meta;

  Products({
    required this.data,
    required this.meta,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    List<Product> data = new List.empty(growable: true);
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(new Product.fromJson(v));
      });
    }
    return Products(
      data: data,
      meta: new Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['meta'] = this.meta;
    map['data'] = this.data.map((v) => v.toJson()).toList();
    return map;
  }
}
