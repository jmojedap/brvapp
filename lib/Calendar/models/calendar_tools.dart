import 'package:brave_app/Config/constants.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

class CalendarTools {
// General
//------------------------------------------------------------------------------

  //Map información de un evento
  Future<Map> getEventInfo(eventId, userId) async {
    var url = kUrlApi + 'calendar/get_event_info/$eventId/$userId';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return response.data['event'];
    } else {
      throw Exception('Error al solicitar información del evento');
    }
  }

// Citas y reservas
//------------------------------------------------------------------------------

  /// Días en los que hay programadas citas por tipo (typeId), incluye la
  /// cantidad de citas que tiene para cada día el usuario (userId)
  /// 2021-10-22
  Future<List<Map>> getAppointmentsDays(userId, typeId) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    var url =
        kUrlApi + 'calendar/get_appointments_days/$userId/$typeId/?$appendAuth';
    print(url);
    var response = await Dio().get(url);

    List<Map> daysList = [];

    if (response.statusCode == 200) {
      final responseBody = response.data;

      for (var item in responseBody['days']) {
        daysList.add(item);
      }
      //print(daysList);
      return daysList;
    } else {
      throw Exception('Error al requerir días con citas');
    }
  }

  /// Citas programadas en un día específico de un tipo especifico
  /// 2021-10-09
  Future<List<Map>> getAppointments(dayId, typeId) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    var url = kUrlApi + 'calendar/get_appointments/$dayId/$typeId/?$appendAuth';
    print(url);
    var response = await Dio().get(url);

    List<Map> appointmentsList = [];

    if (response.statusCode == 200) {
      final responseBody = response.data;

      for (var item in responseBody['list']) {
        appointmentsList.add(item);
      }
      //print(appointmentsList);
      return appointmentsList;
    } else {
      throw Exception('Error al requerir listado de citas');
    }
  }

  /// Enviar datos de formulario y recibir datos de validación
  /// 2021-10-09
  Future<Map> reservateAppointment(appointmentId, userId) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    String url = kUrlApi +
        'calendar/reservate_appointment/$appointmentId/$userId/?$appendAuth';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      throw Exception('Error al reservar cita');
    }
  }

  /// Cancelar una cita programada de un usuario
  /// 2021-10-12
  Future<Map> cancelAppointment(appointmentId, userId) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    String url = kUrlApi +
        'calendar/cancel_appointment/$appointmentId/$userId/?$appendAuth';
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al cancelar cita');
    }
  }
}
