import 'package:apate/data/models/residence.dart';

class ResidenceResponse {
  Residence data;

  ResidenceResponse({
    required this.data,
  });

  factory ResidenceResponse.fromJson(Map<String, dynamic> json) {
    return ResidenceResponse(
      data: Residence.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['data'] = this.data;
    return map;
  }
}
