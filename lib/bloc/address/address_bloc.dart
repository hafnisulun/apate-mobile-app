import 'package:apate/data/models/cluster.dart';
import 'package:apate/data/models/residence.dart';
import 'package:apate/data/repositories/cluster_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final ClusterRepository _clusterRepository;

  AddressBloc(this._clusterRepository) : super(AddressIdle()) {
    on<AddressClustersFetchEvent>(_onAddressClusterFetchEvent);
  }

  @override
  void onTransition(Transition<AddressEvent, AddressState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onAddressClusterFetchEvent(
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
