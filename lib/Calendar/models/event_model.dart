import 'dart:convert';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:brave_app/Config/constants.dart';

class EventModel {
// Variables
//------------------------------------------------------------------------------
  final Map<DateTime, List<CleanCalendarEvent>> events = {};

// Funciones
//------------------------------------------------------------------------------

  //Map con dia -> eventos CCE, para llenar Clear Calendar
  Map<DateTime, List<CleanCalendarEvent>> getEvents() {
    List _mapDaysWithEvents = mapDaysWithEvents();

    //Llenar events, a partir de mapDaysWithEvents
    _mapDaysWithEvents.forEach((day) {
      events[DateTime.parse(day['date'])] = dayEvents(day);
    });
    return events;
  }

  //Lista con Eventos CCE, a partir de Map day['events']
  List<CleanCalendarEvent> dayEvents(day) {
    List<CleanCalendarEvent> _dayEvents = [];

    day['events'].forEach((event) {
      _dayEvents.add(
        CleanCalendarEvent(
          event['title'],
          startTime: DateTime.parse(event['start']),
          endTime: DateTime.parse(event['end']),
          color: kBgColors['room_' + event['related_2']],
        ),
      );
    });

    return _dayEvents;
  }

  //Lista de Días con Eventos, decoficando string JSON
  List mapDaysWithEvents() {
    String _jsonDaysWithEvents = jsonDaysWithEvents();
    Map _decodedJson = jsonDecode(_jsonDaysWithEvents);
    List _days = _decodedJson['days'];

    List _mapDaysWithEvents = [];
    _days.forEach((day) {
      _mapDaysWithEvents.add(day);
    });

    return _mapDaysWithEvents;
  }

  //String en formado JSON, con días y sus eventos
  String jsonDaysWithEvents() {
    String _jsonDaysWithEvents = '''
      {"days":[{"id":"20210806","date":"2021-08-06","events":[{"id":"1218","title":"Zona 3 Ejercicio funcional","type_id":"213","start":"2021-08-06 05:00:00","end":"2021-08-06 06:00:00","day_id":"20210806","related_2":"30"}]},{"id":"20210809","date":"2021-08-09","events":[{"id":"608","title":"Zona 3 Ejercicio funcional","type_id":"213","start":"2021-08-09 09:00:00","end":"2021-08-09 10:00:00","day_id":"20210809","related_2":"30"},{"id":"1260","title":"Zona 5 Fuerza del core TRX","type_id":"213","start":"2021-08-09 17:20:00","end":"2021-08-09 18:20:00","day_id":"20210809","related_2":"50"}]},{"id":"20210811","date":"2021-08-11","events":[{"id":"674","title":"Zona 1 Resistencia","type_id":"213","start":"2021-08-11 05:00:00","end":"2021-08-11 06:00:00","day_id":"20210811","related_2":"10"},{"id":"1296","title":"Zona 4 Boxeo y MMA","type_id":"213","start":"2021-08-11 05:00:00","end":"2021-08-11 06:00:00","day_id":"20210811","related_2":"40"}]},{"id":"20210818","date":"2021-08-18","events":[{"id":"1123","title":"Zona 3 Ejercicio funcional","type_id":"213","start":"2021-08-18 09:00:00","end":"2021-08-18 10:00:00","day_id":"20210818","related_2":"30"},{"id":"1405","title":"Zona 5 Fuerza del core TRX","type_id":"213","start":"2021-08-18 16:00:00","end":"2021-08-18 15:00:00","day_id":"20210818","related_2":"50"}]}]}
    ''';

    return _jsonDaysWithEvents;
  }
}
