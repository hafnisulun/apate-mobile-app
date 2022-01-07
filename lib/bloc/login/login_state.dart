part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String message;

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? message,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [email, password, status, message];
}

// class LoginState extends Equatable {
//   const LoginState({
//     this.status = 'idle',
//     this.message = '',
//     this.email = '',
//     this.password = '',
//   });
//
//   final String status;
//   final String message;
//   final String email;
//   final String password;
//
//   LoginState copyWith({
//     String? status,
//     String? message,
//     String? email,
//     String? password,
//   }) {
//     return LoginState(
//       status: status ?? this.status,
//       message: message ?? this.message,
//       email: email ?? this.email,
//       password: password ?? this.password,
//     );
//   }
//
//   @override
//   List<Object> get props => [status, message, email, password];
// }
