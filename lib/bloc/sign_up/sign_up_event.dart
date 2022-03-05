part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpEmailChange extends SignUpEvent {
  const SignUpEmailChange({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignUpPasswordChange extends SignUpEvent {
  const SignUpPasswordChange({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignUpPasswordMaskToggle extends SignUpEvent {}

class SignUpNameChange extends SignUpEvent {
  const SignUpNameChange({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class SignUpFormSubmit extends SignUpEvent {}
