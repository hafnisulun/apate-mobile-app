import 'package:apate/bloc/login/login_bloc.dart';
import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
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
                                    'assets/images/apate_a_blue_logo.png'),
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
                                SignUpView(),
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
          LogInButton(),
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
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: state.isPasswordMasked
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
                onPressed: () {
                  context.read<LoginBloc>().add(PasswordMaskToggle());
                },
              ),
            ),
            obscureText: state.isPasswordMasked,
            onChanged: (value) {
              context.read<LoginBloc>().add(PasswordChanged(password: value));
            },
          ),
        );
      },
    );
  }
}

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            width: double.infinity,
            child: AptFlatButton(
              onPressed: state.status.isValidated
                  ? () => context.read<LoginBloc>().add(FormSubmitted())
                  : null,
              text: 'MASUK',
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
            content: Text('Lupa password'),
          ),
        ),
        child: Text('Lupa password?'),
      ),
    );
  }
}

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text('Belum memiliki akun?'),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Daftar'),
              ),
            ),
            child: Text('Daftar'),
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
