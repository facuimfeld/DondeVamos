part of 'event_bloc.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}

class AllEventsLoaded extends EventState {
  List<Event> events = [];
  AllEventsLoaded({required this.events});
}

class AllEventsNearbyLoaded extends EventState {
  List<Event> events = [];
  AllEventsNearbyLoaded({required this.events});
}

class LoadEventsLoading extends EventState {}

class DaysLoaded extends EventState {
  List<HourEvent> hoursEvents = [];
  DaysLoaded({required this.hoursEvents});
}

class DaysLoading extends EventState {}
