import 'package:apate/bloc/sign_up/sign_up_bloc.dart';
import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/components/dialog_background.dart';
import 'package:apate/components/loading_dialog.dart';
import 'package:apate/data/repositories/account_repository.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/screens/home_screen.dart';
import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpScreen extends StatelessWidget {
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
        create: (context) => SignUpBloc(
          AccountRepository(),
          LoginRepository(),
        ),
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
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (_) => false,
          );
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
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
                OpacityView(),
                LoadingView(),
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
          NameInput(),
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
        onChanged: (value) =>
            context.read<SignUpBloc>().add(SignUpEmailChange(email: value)),
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
            onChanged: (value) => context
                .read<SignUpBloc>()
                .add(SignUpPasswordChange(password: value)),
          );
        },
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nama',
        ),
        textInputAction: TextInputAction.next,
        onChanged: (value) =>
            context.read<SignUpBloc>().add(SignUpNameChange(name: value)),
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
        child: BlocBuilder<SignUpBloc, SignUpState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return AptFlatButton(
              onPressed: state.status.isValidated
                  ? () => context.read<SignUpBloc>().add(SignUpFormSubmit())
                  : null,
              text: 'DAFTAR',
            );
          },
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

class OpacityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return DialogBackground();
        } else {
          return Container();
        }
      },
    );
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return Center(
            child: LoadingDialog(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
