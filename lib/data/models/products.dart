import 'package:apate/data/models/product.dart';

class Products {
  List<Product> data;
  Meta meta;

  Products({
    this.data,
    this.meta,
  });

  Products.fromJson(Map<String, dynamic> json) {
    meta = new Meta.fromJson(json['meta']);
    if (json['data'] != null) {
      data = new List<Product>();
      json['data'].forEach((v) {
        data.add(new Product.fromJson(v));
      });
    }
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
    this.page,
    this.limit,
    this.totalResults,
    this.totalPages,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    totalResults = json['totalResults'];
    limit = json['limit'];
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
