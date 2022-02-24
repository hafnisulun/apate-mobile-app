part of 'residence_bloc.dart';

abstract class ResidenceState extends Equatable {
  const ResidenceState();
}

class ResidenceFetchUnauthorized extends ResidenceState {
  @override
  List<Object> get props => [];
}

class ResidenceFetchIdle extends ResidenceState {
  @override
  List<Object> get props => [];
}

class ResidenceFetchLoading extends ResidenceState {
  @override
  List<Object> get props => [];
}

class ResidenceFetchSuccess extends ResidenceState {
  final Residence residence;

  const ResidenceFetchSuccess({required this.residence});

  @override
  List<Object> get props => [residence];
}

class ResidenceFetchError extends ResidenceState {
  final String message;

  const ResidenceFetchError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ResidenceFetchError { message: $message }';
}
