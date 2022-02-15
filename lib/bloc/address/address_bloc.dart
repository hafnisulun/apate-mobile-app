import 'package:apate/data/inputs/residence_input.dart';
import 'package:apate/data/models/residence.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressState()) {
    on<AddressResidenceChangeEvent>(_onAddressResidenceChangeEvent);
    on<AddressSubmitEvent>(_onAddressSubmitEvent);
  }

  @override
  void onTransition(Transition<AddressEvent, AddressState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onAddressResidenceChangeEvent(
    AddressResidenceChangeEvent event,
    Emitter<AddressState> emit,
  ) {
    final residenceInput = ResidenceInput.dirty(event.residenceInput);
    emit(state.copyWith(
      residence: event.residence,
      residenceInput: residenceInput.valid
          ? residenceInput
          : ResidenceInput.pure(event.residenceInput),
      status: Formz.validate([residenceInput]),
    ));
  }

  void _onAddressSubmitEvent(
      AddressSubmitEvent event, Emitter<AddressState> emit) async {
    print(
        '[AddressBloc] [_onAddressSubmitEvent] residence: ${state.residence.toJson()}');
    print(
        '[AddressBloc] [_onAddressSubmitEvent] residenceInput: ${state.residenceInput}');
  }
}
