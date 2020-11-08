import 'package:apate/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          color: Colors.green,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/apate_a_white_logo.png"),
                  height: 192,
                ),
                SizedBox(height: 128),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (_) => false,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/google_g_logo.png"),
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'Masuk dengan Google',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}
