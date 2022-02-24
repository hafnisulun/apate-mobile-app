import 'package:apate/data/models/cluster.dart';
import 'package:apate/data/models/residence.dart';
import 'package:apate/data/repositories/cluster_repository.dart';
import 'package:apate/data/repositories/residence_repository.dart';
import 'package:apate/data/responses/cluster_response.dart';
import 'package:apate/data/responses/residence_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final ClusterRepository _clusterRepository;

  AddressBloc(this._clusterRepository) : super(AddressIdle()) {
    on<AddressResidenceFetchEvent>(_onAddressResidenceFetchEvent);
    on<AddressResidenceChangeEvent>(_onAddressResidenceChangeEvent);
    on<AddressClusterFetchEvent>(_onAddressClusterFetchEvent);
    on<AddressClustersFetchEvent>(_onAddressClustersFetchEvent);
  }

  @override
  void onTransition(Transition<AddressEvent, AddressState> transition) {
    print('[AddressBloc] [onTransition] $transition');
    super.onTransition(transition);
  }

  void _onAddressResidenceFetchEvent(
      AddressResidenceFetchEvent event, Emitter<AddressState> emit) async {
    print('event.residenceUuid ${event.residenceUuid}');
    emit(AddressResidenceFetchLoading());
    try {
      final ResidenceResponse? residence =
          await ResidenceRepository().getResidence(event.residenceUuid);
      print('[ResidenceBloc] [_onResidenceFetchEvent] getResidence done');
      if (residence == null) {
        emit(AddressResidenceFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(AddressResidenceFetchSuccess(residence: residence.data));
      }
    } on DioError catch (e) {
      print('[ResidenceBloc] [_onResidenceFetchEvent] exception response' +
          ' code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AddressResidenceFetchUnauthorized());
      } else {
        emit(AddressResidenceFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }

  void _onAddressResidenceChangeEvent(
      AddressResidenceChangeEvent event, Emitter<AddressState> emit) async {
    emit(AddressResidenceChangeSuccess(residence: event.residence));
  }

  void _onAddressClusterFetchEvent(
      AddressClusterFetchEvent event, Emitter<AddressState> emit) async {
    print('event.residence: ${event.residence}');
    print('event.clusterUuid: ${event.clusterUuid}');
    emit(AddressClusterFetchLoading());
    try {
      final ClusterResponse? cluster = await _clusterRepository.getCluster(
          event.residence.uuid, event.clusterUuid);
      print('[ClusterBloc] [_onClusterFetchEvent] getCluster done');
      if (cluster == null) {
        emit(AddressClusterFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(AddressClusterFetchSuccess(
          residence: event.residence,
          cluster: cluster.data,
        ));
      }
    } on DioError catch (e) {
      print(
          '[ClusterBloc] [_onClusterFetchEvent] exception response code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AddressClusterFetchUnauthorized());
      } else {
        emit(AddressClusterFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }

  void _onAddressClustersFetchEvent(
      AddressClustersFetchEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressClustersFetchLoading());
      print(
          '[AddressBloc] [_onAddressClusterFetchEvent] residence UUID: ${event.residence.uuid}');
      final clustersResponse =
          await _clusterRepository.getClusters(event.residence.uuid);
      if (clustersResponse == null) {
        emit(AddressClustersFetchError(message: "Koneksi internet terputus"));
      } else {
        emit(AddressClustersFetchSuccess(clusters: clustersResponse.data));
      }
    } on DioError catch (e) {
      print(
          '[AddressBloc] [_onAddressClusterFetchEvent] exception response code: ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        emit(AddressClustersFetchUnauthorized());
      } else {
        emit(AddressClustersFetchError(message: 'Koneksi internet terputus'));
      }
    }
  }
}
