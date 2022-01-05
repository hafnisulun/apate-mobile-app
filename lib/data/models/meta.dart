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
      total: json['total'],
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
