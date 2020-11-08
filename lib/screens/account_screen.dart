import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun"),
        automaticallyImplyLeading: true,
      ),
      body: FlatButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              (_) => false,
            );
          },
          child: Text("Keluar")),
    );
  }
}
