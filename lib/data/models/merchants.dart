import 'package:apate/data/models/merchant.dart';

class Merchants {
  List<Merchant> data;
  Meta meta;

  Merchants({
    this.data,
    this.meta,
  });

  Merchants.fromJson(Map<String, dynamic> json) {
    meta = new Meta.fromJson(json['meta']);
    if (json['data'] != null) {
      data = new List<Merchant>();
      json['data'].forEach((v) {
        data.add(new Merchant.fromJson(v));
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
  int count;
  int total;
  int page;
  int limit;

  Meta({
    this.count,
    this.total,
    this.page,
    this.limit,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
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
