import 'package:apate/data/inputs/cluster_input.dart';
import 'package:apate/data/inputs/residence_input.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'address_form_event.dart';

part 'address_form_state.dart';

class AddressFormBloc extends Bloc<AddressFormEvent, AddressFormState> {
  AddressFormBloc() : super(AddressFormState()) {
    on<AddressFormResidenceChangeEvent>(_onAddressFormResidenceChangeEvent);
    on<AddressFormClusterChangeEvent>(_onAddressFormClusterChangeEvent);
    on<AddressFormSubmitEvent>(_onAddressSubmitEvent);
  }

  @override
  void onTransition(Transition<AddressFormEvent, AddressFormState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onAddressFormResidenceChangeEvent(
      AddressFormResidenceChangeEvent event, Emitter<AddressFormState> emit) {
    final residenceInput = ResidenceInput.dirty(event.residenceUuid);
    print(
        '[AddressFormBloc] [_onAddressResidenceChangeEvent] residenceInput.value: ${residenceInput.value}');
    emit(state.copyWith(
      residenceInput: residenceInput.valid
          ? residenceInput
          : ResidenceInput.pure(event.residenceUuid),
      status: Formz.validate([residenceInput, state.clusterInput]),
    ));
  }

  void _onAddressFormClusterChangeEvent(
      AddressFormClusterChangeEvent event, Emitter<AddressFormState> emit) {
    final clusterInput = ClusterInput.dirty(event.clusterUuid);
    print(
        '[AddressFormBloc] [_onAddressFormClusterChangeEvent] clusterInput.value: ${clusterInput.value}');
    emit(state.copyWith(
      clusterInput: clusterInput.valid
          ? clusterInput
          : ClusterInput.pure(event.clusterUuid),
      status: Formz.validate([state.residenceInput, clusterInput]),
    ));
  }

  void _onAddressSubmitEvent(
      AddressFormSubmitEvent event, Emitter<AddressFormState> emit) async {
    print('[AddressFormBloc] [_onAddressSubmitEvent] state: $state');
  }
}
