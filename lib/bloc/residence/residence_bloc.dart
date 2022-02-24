import 'package:apate/data/models/residence.dart';
import 'package:apate/data/repositories/residence_repository.dart';
import 'package:apate/data/responses/residence_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'residence_event.dart';

part 'residence_state.dart';

class ResidenceBloc extends Bloc<ResidenceEvent, ResidenceState> {
  final ResidenceRepository _residenceRepository;

  ResidenceBloc(this._residenceRepository) : super(ResidenceFetchIdle()) {
    on<ResidenceFetchEvent>(_onResidenceFetchEvent);
  }

  void _onResidenceFetchEvent(
      ResidenceFetchEvent event, Emitter<ResidenceState> emit) async {
    print('event.residenceUuid ${event.residenceUuid}');
    if (event.residenceUuid != null && event.residenceUuid != null) {
      emit(ResidenceFetchLoading());
      try {
        final ResidenceResponse? residence =
            await _residenceRepository.getResidence(event.residenceUuid!);
        print('[ResidenceBloc] [_onResidenceFetchEvent] getResidence done');
        if (residence == null) {
          emit(ResidenceFetchError(message: "Koneksi internet terputus"));
        } else {
          emit(ResidenceFetchSuccess(residence: residence.data));
        }
      } on DioError catch (e) {
        print('[ResidenceBloc] [_onResidenceFetchEvent] exception response' +
            ' code: ${e.response?.statusCode}');
        if (e.response?.statusCode == 401) {
          emit(ResidenceFetchUnauthorized());
        } else {
          emit(ResidenceFetchError(message: 'Koneksi internet terputus'));
        }
      }
    }
  }
}
