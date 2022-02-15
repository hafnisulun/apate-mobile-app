import 'package:apate/data/models/meta.dart';
import 'package:apate/data/models/residence.dart';

class ResidencesResponse {
  List<Residence> data;
  Meta? meta;

  ResidencesResponse({
    required this.data,
    this.meta,
  });

  factory ResidencesResponse.fromJson(Map<String, dynamic> json) {
    List<Residence> data = new List.empty(growable: true);
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Residence.fromJson(v));
      });
    }
    return ResidencesResponse(
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['meta'] = this.meta;
    map['data'] = this.data.map((v) => v.toJson()).toList();
    return map;
  }
}
