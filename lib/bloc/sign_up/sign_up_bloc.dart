import 'package:apate/data/models/email.dart';
import 'package:apate/data/models/password.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState()) {
    on<SignUpPasswordMaskToggle>(_onSignUpPasswordMaskToggle);
  }

  @override
  void onTransition(Transition<SignUpEvent, SignUpState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onSignUpPasswordMaskToggle(
    SignUpPasswordMaskToggle event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      isPasswordMasked: !state.isPasswordMasked,
      status: Formz.validate([state.email, password]),
    ));
  }
}
