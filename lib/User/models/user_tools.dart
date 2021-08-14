import 'dart:convert';
import 'package:brave_app/Config/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class UserTools {
  //Map respuesta cancelación de una reservación
  Future<Map> getInfo(userId, format) async {
    var url = Uri.parse(kUrlApi + 'users/get_info/$userId/$format');
    print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final mapResponse = jsonDecode(response.body);
      print(mapResponse);
      return mapResponse;
    } else {
      throw Exception('Error al requerir información sobre el usuario');
    }
  }
}
