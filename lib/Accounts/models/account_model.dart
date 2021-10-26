import 'package:brave_app/Config/constants.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

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
    print(url);
    var data = FormData.fromMap(formData);

    var response = await Dio().post(url, data: data);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al validar datos de login');
    }
  }

  //Actualizar los datos básicos del perfil de usuario en el BackEnd
  //2021-09-24
  Future<Map> updateProfile(String userId, bodyData) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    String url = kUrlApi + 'accounts/update/$userId/?$appendAuth';
    print(url);
    var formData = FormData.fromMap(bodyData);
    var response = await Dio().post(
      url,
      data: formData,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al actualizar datos de usuario');
    }
  }

  //Establecer una imagen de perfil de usuario
  //2021-09-21
  Future<Map> setPicture(filepath) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    var url = kUrlApi + 'accounts/set_image/?$appendAuth';
    print(url);
    var formData = FormData.fromMap({
      'file_field':
          await MultipartFile.fromFile(filepath, filename: 'user_picture.jpg')
    });
    var response = await Dio().post(url, data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error al cargar imagen de perfil del usuario');
    }
  }

  //Enviar datos de formulario y recibir datos de validación
  Future<Map> changePassword(String userId, bodyData) async {
    String appendAuth = UserSimplePreferences.getAppendAuth();
    String url = kUrlApi + 'accounts/change_password/?' + appendAuth;
    print(url);
    var formData = FormData.fromMap(bodyData);
    var response = await Dio().post(url, data: formData);

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      throw Exception('Error al actualizar la contraseña');
    }
  }
}
