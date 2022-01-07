import 'package:apate/bloc/login/login_bloc.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (_) => false,
          );
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
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
                                LoginForm(),
                                ForgotPasswordButton(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 24,
                                  ),
                                  child: Divider(color: Colors.grey),
                                ),
                                SignUpButton(),
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
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailInput(),
          PasswordInput(),
          SubmitButton(),
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
        onChanged: (value) {
          context.read<LoginBloc>().add(EmailChanged(email: value));
        },
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
        ),
        obscureText: true,
        onChanged: (value) {
          context.read<LoginBloc>().add(PasswordChanged(password: value));
        },
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.status.isValidated
                  ? () => context.read<LoginBloc>().add(FormSubmitted())
                  : null,
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 16.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Masuk'),
            ),
          ),
        );
      },
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Forgot password'),
          ),
        ),
        child: Text('Forgot password?'),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sign up'),
              ),
            ),
            child: Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class OpacityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.status.isSubmissionInProgress) {
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
      if (state.status.isSubmissionInProgress) {
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
