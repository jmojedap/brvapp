import 'package:brave_app/Config/constants.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class UserTools {
  //Map información de un usuario
  Future<Map> getInfo(userId, format) async {
    var url = kUrlApi + 'users/get_info/$userId/$format';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al requerir información sobre el usuario');
    }
  }

  //Map con información de userKey de un ususuario
  Future<Map> getUserKey(userId) async {
    var url = kUrlApi + 'accounts/get_userkey/0IEM5CCSJ97LWC7L/$userId/';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al requerir userKey de $userId');
    }
  }
}
