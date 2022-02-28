part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isPasswordMasked = true,
    this.status = FormzStatus.pure,
    this.message = '',
  });

  final Email email;
  final Password password;
  final bool isPasswordMasked;
  final FormzStatus status;
  final String message;

  LoginState copyWith({
    Email? email,
    Password? password,
    bool? isPasswordMasked,
    FormzStatus? status,
    String? message,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordMasked: isPasswordMasked ?? this.isPasswordMasked,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isPasswordMasked,
        status,
        message,
      ];
}
