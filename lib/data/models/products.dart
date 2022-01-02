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
    return Products(data: data, meta: new Meta.fromJson(json['meta']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['meta'] = this.meta;
    if (this.data != null) {
      map['results'] = this.data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Meta {
  int page;
  int limit;
  int totalResults;
  int totalPages;

  Meta({
    required this.page,
    required this.limit,
    required this.totalResults,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      limit: json['limit'],
      totalResults: json['totalResults'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['page'] = this.page;
    map['limit'] = this.limit;
    map['totalResults'] = this.totalResults;
    map['totalPages'] = this.totalPages;
    return map;
  }
}
