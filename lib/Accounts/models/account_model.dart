import 'package:brave_app/Config/constants.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class AccountModel {
  //Validar usuario y contraseña para iniciar sesión de usuario
  //2021-09-21
  Future<Map> validateLogin(String username, String password) async {
    var url = kUrlApi + 'accounts/validate_login';
    var formData =
        FormData.fromMap({'username': username, 'password': password});

    var response = await Dio().post(url, data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al validar datos de login');
    }
  }

  //Crear una cuenta de usuario
  //2021-09-21
  Future<Map> signUp(Map formData) async {
    var url = kUrlApi + 'accounts/register';
    var data = FormData.fromMap(formData);

    var response = await Dio().post(url, data: data);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al validar datos de login');
    }
  }

  //Establecer una imagen de perfil de usuario
  //2021-09-21
  Future<Map> setPicture(String userId, String userKey, filepath) async {
    var url = kUrlApi + 'accounts/set_image/$userId/$userKey';
    print(filepath);
    print(url);
    var formData = FormData.fromMap({
      'file_field': await MultipartFile.fromFile(filepath, filename: 'file.jpg')
    });
    var response = await Dio().post(url, data: formData);

    if (response.statusCode == 200) {
      print(response);
      return response.data;
    } else {
      throw Exception('Error al cargar imagen de perfil de $userId');
    }
  }
}
