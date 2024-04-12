part of 'businesshours_bloc.dart';

sealed class BusinesshoursState extends Equatable {
  const BusinesshoursState();

  @override
  List<Object> get props => [];
}

/// è lo stato iniziale senza attributi
final class InitialBusinesshoursState extends BusinesshoursState {}

final class InitializingBusinesshoursState extends BusinesshoursState {}

/// contiene la lista di giorni ed orari
final class InitializedBusinesshoursState extends BusinesshoursState {
  const InitializedBusinesshoursState(this.businessHours);

  final BusinessHours businessHours;

  @override
  List<Object> get props => [businessHours.props];
}
