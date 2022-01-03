import 'package:apate/bloc/login/login_bloc.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(LoginRepository()),
        child: LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == 'success') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (_) => false,
          );
        } else if (state.status == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          context.read<LoginBloc>().add(LoginErrorShown());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
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
                                    'assets/images/apate_a_green_logo.png'),
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
                  ),
                  OpacityView(),
                  LoadingView(),
                ],
              );
            },
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<LoginBloc>().add(EmailChanged(email: value));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) {
                context.read<LoginBloc>().add(PasswordChanged(password: value));
              },
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
    context.read<LoginBloc>().add(LoginSubmitted());
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

class OpacityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.status == 'submitting') {
        return Opacity(
          opacity: 0.7,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.status == 'submitting') {
        return Center(
          child: AlertDialog(
            content: new Row(
              children: [
                CircularProgressIndicator(),
                Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text("Loading...")),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
