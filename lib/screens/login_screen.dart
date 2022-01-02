import 'package:apate/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 128,
                      bottom: 64,
                    ),
                    child: Center(
                      child: Image(
                        image:
                            AssetImage('assets/images/apate_a_green_logo.png'),
                        height: 128,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: <Widget>[
                        _buildLoginForm(context),
                        _buildForgotPasswordButton(context),
                        _buildDivider(context),
                        _buildRegisterButton(context),
                      ],
                    ),
                  ),
                ],
              ), // your column
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _logIn(context),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('LOG IN'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () => _forgotPassword(context),
        child: Text('Forgot password?'),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 24,
      ),
      child: Divider(color: Colors.grey),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: () => _signUp(context),
            child: Text('Sign up'),
          ),
        ],
      ),
    );
  }

  void _logIn(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (_) => false,
    );
  }

  void _forgotPassword(BuildContext context) async {
    print('forgot password');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Forgot password'),
      ),
    );
  }

  void _signUp(BuildContext context) async {
    print('sign up');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up'),
      ),
    );
  }
}
