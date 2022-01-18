part of 'cluster_bloc.dart';

abstract class ClusterEvent extends Equatable {
  const ClusterEvent();

  @override
  List<Object> get props => [];
}

class ClusterFetchEvent extends ClusterEvent {
  final String? residenceUuid;
  final String? clusterUuid;

  const ClusterFetchEvent({
    this.residenceUuid,
    this.clusterUuid,
  });

  @override
  List<Object> get props => [residenceUuid!, clusterUuid!];
}
