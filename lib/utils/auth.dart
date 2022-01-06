import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';

class Auth {
  static void logout(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),
      (_) => false,
    );
  }
}
