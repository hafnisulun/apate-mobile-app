import 'package:apate/data/models/merchant.dart';

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
    map['results'] = this.data.map((v) => v.toJson()).toList();
    return map;
  }
}

class Meta {
  int? count;
  int? total;
  int? page;
  int? limit;

  Meta({
    this.count,
    this.total,
    this.page,
    this.limit,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      count: json['count'],
      total: json['totalResults'],
      page: json['page'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['count'] = this.count;
    map['total'] = this.total;
    map['page'] = this.page;
    map['limit'] = this.limit;
    return map;
  }
}
