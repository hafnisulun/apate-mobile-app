import 'package:apate/data/inputs/address_details_input.dart';
import 'package:apate/data/inputs/address_label_input.dart';
import 'package:apate/data/inputs/cluster_input.dart';
import 'package:apate/data/inputs/residence_input.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/address_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'address_form_event.dart';

part 'address_form_state.dart';

class AddressFormBloc extends Bloc<AddressFormEvent, AddressFormState> {
  AddressFormBloc() : super(AddressFormState()) {
    on<AddressFormLabelChangeEvent>(_onAddressFormLabelChangeEvent);
    on<AddressFormResidenceChangeEvent>(_onAddressFormResidenceChangeEvent);
    on<AddressFormClusterChangeEvent>(_onAddressFormClusterChangeEvent);
    on<AddressFormDetailChangeEvent>(_onAddressFormDetailChangeEvent);
    on<AddressFormSubmitEvent>(_onAddressSubmitEvent);
  }

  @override
  void onTransition(Transition<AddressFormEvent, AddressFormState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onAddressFormLabelChangeEvent(
      AddressFormLabelChangeEvent event, Emitter<AddressFormState> emit) {
    final labelInput = AddressLabelInput.dirty(event.label);
    print(
        '[AddressFormBloc] [_onAddressFormLabelChangeEvent] labelInput.value: +${labelInput.value}');
    emit(state.copyWith(
      labelInput:
          labelInput.valid ? labelInput : AddressLabelInput.pure(event.label),
      status: Formz.validate([
        labelInput,
        state.residenceInput,
        state.clusterInput,
        state.detailInput,
      ]),
    ));
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
      status: Formz.validate([
        state.labelInput,
        residenceInput,
        state.clusterInput,
        state.detailInput,
      ]),
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
      status: Formz.validate([
        state.labelInput,
        state.residenceInput,
        clusterInput,
        state.detailInput,
      ]),
    ));
  }

  void _onAddressFormDetailChangeEvent(
      AddressFormDetailChangeEvent event, Emitter<AddressFormState> emit) {
    final detailInput = AddressDetailsInput.dirty(event.detail);
    print(
        '[AddressFormBloc] [_onAddressFormLabelChangeEvent] detailInput.value: ${detailInput.value}');
    emit(state.copyWith(
      detailInput: detailInput.valid
          ? detailInput
          : AddressDetailsInput.pure(event.detail),
      status: Formz.validate([
        state.labelInput,
        state.residenceInput,
        state.clusterInput,
        detailInput,
      ]),
    ));
  }

  void _onAddressSubmitEvent(
      AddressFormSubmitEvent event, Emitter<AddressFormState> emit) async {
    print('[AddressFormBloc] [_onAddressSubmitEvent] state: $state');
    final labelInput = AddressLabelInput.dirty(state.labelInput.value);
    final residenceInput = ResidenceInput.dirty(state.residenceInput.value);
    final clusterInput = ClusterInput.dirty(state.clusterInput.value);
    final detailsInput = AddressDetailsInput.dirty(state.detailInput.value);
    emit(state.copyWith(
      labelInput: labelInput,
      residenceInput: residenceInput,
      clusterInput: clusterInput,
      detailInput: detailsInput,
      status: Formz.validate(
          [labelInput, residenceInput, clusterInput, detailsInput]),
    ));
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      final address = Address(
        label: labelInput.value,
        residenceUuid: residenceInput.value,
        clusterUuid: clusterInput.value,
        details: detailsInput.value,
      );

      try {
        var login = await AddressRepository().createAddress(address);
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
            message: 'Unauthorized',
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
