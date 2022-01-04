import 'package:apate/data/repositories/login_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginState()) {
    on<LoginErrorShown>(_onLoginErrorShown);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onLoginErrorShown(LoginErrorShown event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      status: 'idle',
      message: '',
    ));
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      status: 'submitting',
      message: '',
      email: state.email,
      password: state.password,
    ));
    try {
      var login = await _loginRepository.doLogin(state.email, state.password);
      if (login == null) {
        emit(state.copyWith(
            status: 'error', message: 'Koneksi internet terputus'));
      } else {
        emit(state.copyWith(status: 'success', message: ''));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: 'error', message: e.toString()));
    }
  }
}
