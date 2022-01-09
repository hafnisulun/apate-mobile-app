import 'package:apate/data/models/account.dart';

class AccountResponse {
  Account data;

  AccountResponse({
    required this.data,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      data: Account.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['data'] = this.data;
    return map;
  }
}
