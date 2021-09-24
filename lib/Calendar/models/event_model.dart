import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class EventModel {
// Variables
//------------------------------------------------------------------------------
  final Map<DateTime, List<CleanCalendarEvent>> events = {};

// Funciones
//------------------------------------------------------------------------------

  //Map con dia -> eventos CCE, para llenar Clear Calendar
  Future<Map<DateTime, List<CleanCalendarEvent>>> getEvents(userId) async {
    var url = kUrlApi + 'calendar/my_events/' + userId;
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      final mapResponse = response.data;
      final List _listDaysWithEvents = listDaysWithEvents(mapResponse);

      //Recorrer días y agregar eventos en formato CCE
      _listDaysWithEvents.forEach((day) {
        events[DateTime.parse(day['date'])] = dayEvents(day);
      });

      return events;
    } else {
      throw Exception('Error al solicitar listado de eventos');
    }
  }

  //Lista de Días que tienen eventos, a partir de JSON decodificado
  List listDaysWithEvents(mapResponse) {
    List _days = mapResponse['days'];

    List _listDaysWithEvents = [];
    _days.forEach((day) {
      _listDaysWithEvents.add(day);
    });

    return _listDaysWithEvents;
  }

  //Lista con Eventos CCE para asignarse a un día específico, a partir de Map day['events']
  List<CleanCalendarEvent> dayEvents(day) {
    List<CleanCalendarEvent> _dayEvents = [];

    day['events'].forEach((event) {
      _dayEvents.add(
        CleanCalendarEvent(
          event['title'],
          startTime: DateTime.parse(event['start']),
          description: 'Entrenamiento',
          endTime: DateTime.parse(event['end']),
          color: kBgColors['room_' + event['related_2']],
          location: event['id'],
          isDone: true,
        ),
      );
    });

    return _dayEvents;
  }

  //Map información de un evento
  Future<Map> getReservatonInfo(eventId, userId) async {
    var url = kUrlApi + 'reservations/get_info/$eventId/$userId';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      final decodedResponse = response.data;
      Map eventInfo = decodedResponse['reservation'];
      print(eventInfo);
      return eventInfo;
    } else {
      throw Exception('Error al solicitar información del evento');
    }
  }

  //Map respuesta cancelación de una reservación
  Future<Map> cancelReservation(eventId, trainingId) async {
    String url = kUrlApi + 'reservations/cancel/$eventId/$trainingId';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      final mapResponse = response.data;
      print(mapResponse);
      return mapResponse;
    } else {
      throw Exception('Error al cancelar una reserva');
    }
  }
}
