import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Daftar'),
        // automaticallyImplyLeading: true,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
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
                              AssetImage('assets/images/apate_a_blue_logo.png'),
                          height: 128,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: <Widget>[
                          SignUpForm(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 24,
                            ),
                            child: Divider(color: Colors.grey),
                          ),
                          LogInView(),
                        ],
                      ),
                    ),
                  ],
                ), // your column
              ),
            ),
          ],
        );
      },
    );
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailInput(),
          PasswordInput(),
          SignUpButton(),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {},
          ),
        ),
        obscureText: true,
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: AptFlatButton(
          onPressed: null,
          text: 'DAFTAR',
        ),
      ),
    );
  }
}

class LogInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text('Sudah memiliki akun?'),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (_) => false,
            ),
            child: Text('Masuk'),
          ),
        ],
      ),
    );
  }
}
