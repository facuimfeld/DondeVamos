part of 'event_bloc.dart';

@immutable
abstract class EventEvent {}

class GetAllEvents extends EventEvent {}

class ReloadEvents extends EventEvent {}

class GetDaysFromEvent extends EventEvent {
  int idEvento;
  GetDaysFromEvent({required this.idEvento});
}

class GetNearbyEvents extends EventEvent {}
