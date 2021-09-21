import 'dart:convert';
import 'package:brave_app/Config/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class UserTools {
  //Map información de un usuario
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

  //Map con información de userKey de un ususuario
  Future<Map> getUserKey(userId) async {
    var url =
        Uri.parse(kUrlApi + 'accounts/get_userkey/0IEM5CCSJ97LWC7L/$userId/');
    print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final mapResponse = jsonDecode(response.body);
      print(mapResponse);
      return mapResponse;
    } else {
      throw Exception('Error al requerir userKey de $userId');
    }
  }
}
