import 'package:brave_app/Config/constants.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

class UserTools {
  /// Map información de un usuario
  /// 2021-10-16
  Future<Map> getInfo(userId, format) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    var url = kUrlApi + 'users/get_info_secure/$userId/$format/?$appendAuth';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      print('getInfo statusCode 200 OK');
      return response.data;
    } else {
      throw Exception('Error al requerir información sobre el usuario');
    }
  }

  /// Map con información de userKey de un ususuario
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
