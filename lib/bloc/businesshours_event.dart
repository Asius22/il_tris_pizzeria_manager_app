part of 'businesshours_bloc.dart';

sealed class BusinesshoursEvent extends Equatable {
  const BusinesshoursEvent();

  @override
  List<Object> get props => [];
}

///quando viene invocato inizializza lo stato iniziale dei giorni di apertura
final class InitializeBusinessHoursEvent extends BusinesshoursEvent {}

/// riceve una data di tipo String in formato DD/MM/YYYY ed una lista di orari
/// e comporta l'aggiunta di una nuova data
final class AddBusinessHoursEvent extends BusinesshoursEvent {
  const AddBusinessHoursEvent(this.giorno, this.orari);

  final String giorno; // stringa in formato DD/MM/YYYY
  final OpeningHours orari;

  @override
  List<Object> get props => [...super.props, giorno, orari];
}

final class SaveAllBusinessHoursEvent extends BusinesshoursEvent {
  const SaveAllBusinessHoursEvent(this.orari);

  final BusinessHours orari;

  @override
  List<Object> get props => [orari.props];
}

/// riceve una data in formato String e la rimuove dagli orari del locale
final class RemoveBusinessHoursEvent extends BusinesshoursEvent {
  const RemoveBusinessHoursEvent(this.giorno);

  final String giorno;
  @override
  List<Object> get props => [...super.props, giorno];
}

final class UpdateBusinessHoursEvent extends BusinesshoursEvent {
  const UpdateBusinessHoursEvent(this.giorno, this.orari) : super();

  final String giorno;
  final OpeningHoursList orari;
}

final class UndoUpdateBusinessHoursEvent extends BusinesshoursEvent {
  const UndoUpdateBusinessHoursEvent() : super();
}
