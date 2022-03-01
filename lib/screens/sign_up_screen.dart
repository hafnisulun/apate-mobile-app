import 'package:apate/bloc/sign_up/sign_up_bloc.dart';
import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: SignUpView(),
      ),
    );
  }
}

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        print('state: $state');
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
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
                              image: AssetImage(
                                  'assets/images/apate_a_blue_logo.png'),
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
      }),
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
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          print('state.isPasswordMasked: ${state.isPasswordMasked}');
          return TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordMasked
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () =>
                    context.read<SignUpBloc>().add(SignUpPasswordMaskToggle()),
              ),
            ),
            obscureText: state.isPasswordMasked,
          );
        },
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
