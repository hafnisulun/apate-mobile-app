class Login {
  Token accessToken;
  Token refreshToken;

  Login({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: Token.fromJson(json['access_token']),
      refreshToken: Token.fromJson(json['refresh_token']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['access_token'] = this.accessToken;
    map['refresh_token'] = this.refreshToken;
    return map;
  }
}

class Token {
  String token;
  String type;
  int expiresIn;

  Token({
    required this.token,
    required this.type,
    required this.expiresIn,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      type: json['type'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['token'] = this.token;
    map['type'] = this.type;
    map['expires_in'] = this.expiresIn;
    return map;
  }
}
