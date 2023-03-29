import 'package:donde_vamos/resources/dates_provider.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';

class EventRepository {
  final EventProvider eventProvider = EventProvider();

  ///
  final PlacesProvider placesProvider = PlacesProvider();

  final DatesProvider datesProvider = DatesProvider();
}
