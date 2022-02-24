part of 'cluster_bloc.dart';

abstract class ClusterState extends Equatable {
  const ClusterState();
}

class ClusterFetchUnauthorized extends ClusterState {
  @override
  List<Object> get props => [];
}

class ClusterFetchIdle extends ClusterState {
  @override
  List<Object> get props => [];
}

class ClusterFetchLoading extends ClusterState {
  @override
  List<Object> get props => [];
}

class ClusterFetchSuccess extends ClusterState {
  final String residenceUuid;
  final Cluster cluster;

  const ClusterFetchSuccess({
    required this.residenceUuid,
    required this.cluster,
  });

  @override
  List<Object> get props => [cluster];
}

class ClusterFetchError extends ClusterState {
  final String message;

  const ClusterFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ClusterFetchError { message: $message }';
}
