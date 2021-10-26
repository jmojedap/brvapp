import 'package:brave_app/Config/constants.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ReservationTools {
// Citas de control nutricional
//------------------------------------------------------------------------------

  /// Obtener listado de días en los que hay entrenamientos para un usuario
  /// específico
  /// 2021-10-09
  Future<List<Map>> getTrainingDays(String userId) async {
    final String urlDays = kUrlApi + 'reservations/get_training_days/$userId';
    final response = await Dio().get(urlDays);

    List<Map> daysList = [];

    if (response.statusCode == 200) {
      final responseBody = response.data;

      for (var item in responseBody['days']) {
        daysList.add(item);
      }
      print(daysList);
      return daysList;
    } else {
      throw Exception('Error al solicitar días de entrenamiento');
    }
  }

  /// Requerir a API listado zonas de entrenamiento en un día específico
  /// 2021-10-09
  Future<List<Map>> getRooms(dayId, userId) async {
    final String urlRooms =
        kUrlApi + 'reservations/get_available_rooms/$dayId/$userId';
    print(urlRooms);
    final response = await Dio().get(urlRooms);

    List<Map> roomsList = [];

    if (response.statusCode == 200) {
      final responseBody = response.data;

      for (var item in responseBody['rooms']) {
        roomsList.add(item);
      }
      return roomsList;
    } else {
      throw Exception('Error al solicitar zonas de entrenamiento');
    }
  }

  /// Requerir a API listado de entrenamientos (horarios)
  /// 2021-10-09
  Future<List<Map>> getTrainings(String dayId, String roomId) async {
    final String urlTrainings =
        kUrlApi + 'trainings/get_trainings/$dayId/$roomId';
    final response = await Dio().get(urlTrainings);

    List<Map> trainingsList = [];

    if (response.statusCode == 200) {
      final responseBody = response.data;

      for (var item in responseBody['list']) {
        trainingsList.add(item);
      }
      return trainingsList;
    } else {
      throw Exception('Error al solicitar listado de entrenamientos');
    }
  }

  /// Enviar datos de formulario y recibir datos de validación
  /// 2021-10-09
  Future<Map> saveReservation(trainingId, userId) async {
    String url = kUrlApi + 'reservations/save/$trainingId/$userId';
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al guardar reservación');
    }
  }
}
