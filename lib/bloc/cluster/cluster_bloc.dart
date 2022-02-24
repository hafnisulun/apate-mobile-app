import 'package:apate/data/models/cluster.dart';
import 'package:apate/data/repositories/cluster_repository.dart';
import 'package:apate/data/responses/cluster_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'cluster_event.dart';
part 'cluster_state.dart';

class ClusterBloc extends Bloc<ClusterEvent, ClusterState> {
  final ClusterRepository _clusterRepository;

  ClusterBloc(this._clusterRepository) : super(ClusterFetchIdle()) {
    on<ClusterFetchEvent>(_onClusterFetchEvent);
  }

  void _onClusterFetchEvent(
      ClusterFetchEvent event, Emitter<ClusterState> emit) async {
    print('event.residenceUuid ${event.residenceUuid}');
    print('event.clusterUuid ${event.clusterUuid}');
    if (event.residenceUuid != null && event.clusterUuid != null) {
      emit(ClusterFetchLoading());
      try {
        final ClusterResponse? cluster = await _clusterRepository.getCluster(
            event.residenceUuid!, event.clusterUuid!);
        print('[ClusterBloc] [_onClusterFetchEvent] getCluster done');
        if (cluster == null) {
          emit(ClusterFetchError(message: "Koneksi internet terputus"));
        } else {
          emit(ClusterFetchSuccess(
            residenceUuid: event.residenceUuid!,
            cluster: cluster.data,
          ));
        }
      } on DioError catch (e) {
        print(
            '[ClusterBloc] [_onClusterFetchEvent] exception response code: ${e.response?.statusCode}');
        if (e.response?.statusCode == 401) {
          emit(ClusterFetchUnauthorized());
        } else {
          emit(ClusterFetchError(message: 'Koneksi internet terputus'));
        }
      }
    }
  }
}
