import 'package:apate/utils/auth.dart';
import 'package:flutter/material.dart';

class SessionExpiredDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sesi Anda telah habis'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Silakan masuk kembali'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("MASUK"),
          onPressed: () => Auth.goToLogInPage(context),
        ),
      ],
    );
  }
}
