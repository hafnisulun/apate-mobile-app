import 'package:apate/data/inputs/name_input.dart';
import 'package:apate/data/models/email.dart';
import 'package:apate/data/models/login.dart';
import 'package:apate/data/models/password.dart';
import 'package:apate/data/repositories/account_repository.dart';
import 'package:apate/data/repositories/login_repository.dart';
import 'package:apate/data/responses/account_response.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AccountRepository _accountRepository;
  final LoginRepository _loginRepository;

  SignUpBloc(
    this._accountRepository,
    this._loginRepository,
  ) : super(SignUpState()) {
    on<SignUpEmailChange>(_onSignUpEmailChange);
    on<SignUpPasswordChange>(_onSignUpPasswordChange);
    on<SignUpPasswordMaskToggle>(_onSignUpPasswordMaskToggle);
    on<SignUpNameChange>(_onSignUpNameChange);
    on<SignUpFormSubmit>(_onSignUpFormSubmit);
  }

  @override
  void onTransition(Transition<SignUpEvent, SignUpState> transition) {
    print('[SignUpBloc] [onTransition] $transition');
    super.onTransition(transition);
  }

  void _onSignUpEmailChange(
    SignUpEmailChange event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([email, state.password, state.nameInput]),
      ),
    );
  }

  void _onSignUpPasswordChange(
    SignUpPasswordChange event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.email, password, state.nameInput]),
      ),
    );
  }

  void _onSignUpPasswordMaskToggle(
    SignUpPasswordMaskToggle event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordMasked: !state.isPasswordMasked,
      ),
    );
  }

  void _onSignUpNameChange(
    SignUpNameChange event,
    Emitter<SignUpState> emit,
  ) {
    final nameInput = NameInput.dirty(event.name);
    emit(
      state.copyWith(
        nameInput: nameInput.valid ? nameInput : NameInput.pure(event.name),
        status: Formz.validate([state.email, state.password, nameInput]),
      ),
    );
  }

  void _onSignUpFormSubmit(
    SignUpFormSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final nameInput = NameInput.dirty(state.nameInput.value);

    emit(
      state.copyWith(
        email: email,
        password: password,
        nameInput: nameInput,
        status: Formz.validate([email, password, nameInput]),
      ),
    );

    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try {
        final AccountResponse? account = await _accountRepository.createAccount(
          email.value,
          password.value,
          nameInput.value,
        );

        if (account == null) {
          emit(
            state.copyWith(
              status: FormzStatus.submissionFailure,
              message: 'Koneksi internet terputus',
            ),
          );
          return;
        }

        final Login? login = await _loginRepository.doLogin(email, password);

        if (login == null) {
          emit(
            state.copyWith(
              status: FormzStatus.submissionFailure,
              message: 'Koneksi internet terputus',
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
          ),
        );
      } on DioError catch (e) {
        String message = 'Koneksi internet terputus';

        if (e.response?.statusCode == 409) {
          message = 'Email sudah digunakan';
        }

        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            message: message,
          ),
        );
      }
    }
  }
}
