part of 'residence_bloc.dart';

abstract class ResidenceEvent extends Equatable {
  const ResidenceEvent();

  @override
  List<Object> get props => [];
}

class ResidenceFetchEvent extends ResidenceEvent {
  final String? residenceUuid;

  const ResidenceFetchEvent({
    this.residenceUuid,
  });

  @override
  List<Object> get props => [residenceUuid!];
}
