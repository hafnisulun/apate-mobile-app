import 'package:apate/data/models/email.dart';
import 'package:apate/data/models/password.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<EmailUnfocused>(_onEmailUnfocused);
    on<PasswordUnfocused>(_onPasswordUnfocused);
    on<PasswordMaskToggle>(_onPasswordMaskToggle);
    on<FormSubmitted>(_onFormSubmitted);
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email.valid ? email : Email.pure(event.email),
      status: Formz.validate([email, state.password]),
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password.valid ? password : Password.pure(event.password),
      status: Formz.validate([state.email, password]),
    ));
  }

  void _onEmailUnfocused(EmailUnfocused event, Emitter<LoginState> emit) {
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void _onPasswordUnfocused(
    PasswordUnfocused event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  void _onPasswordMaskToggle(
    PasswordMaskToggle event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      isPasswordMasked: !state.isPasswordMasked,
      status: Formz.validate([state.email, password]),
    ));
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<LoginState> emit) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      email: email,
      password: password,
      status: Formz.validate([email, password]),
    ));
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        var login = await _loginRepository.doLogin(state.email, state.password);
        if (login == null) {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Koneksi internet terputus',
          ));
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
          ));
        }
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Email atau password salah',
          ));
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Koneksi internet terputus',
          ));
        }
      }
    }
  }
}
