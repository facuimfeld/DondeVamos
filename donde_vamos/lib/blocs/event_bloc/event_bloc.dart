import 'package:bloc/bloc.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/hour_event.dart';
import 'package:donde_vamos/resources/event_repository.dart';
import 'package:meta/meta.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventRepository repository;
  EventBloc({required this.repository}) : super(EventInitial()) {
    on<GetAllEvents>((event, emit) async {
      try {
        emit(LoadEventsLoading());
        List<Event> events = await repository.eventProvider.getEvents();
        emit(AllEventsLoaded(events: events));
      } catch (e) {
        print(e.toString());
      }
    });
    on<GetNearbyEvents>((event, emit) async {
      try {
        // emit(LoadEventsLoading());
        List<Event> events = await repository.eventProvider.getNearbyEvents();
        emit(AllEventsNearbyLoaded(events: events));
      } catch (e) {
        print(e.toString());
      }
    });
    on<GetDaysFromEvent>((event, emit) async {
      try {
        emit(DaysLoading());
        List<HourEvent> hourevents =
            await repository.datesProvider.getDaysFromEvent(event.idEvento);
        emit(DaysLoaded(hoursEvents: hourevents));
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
