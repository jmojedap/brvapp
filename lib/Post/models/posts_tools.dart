import 'package:brave_app/Config/constants.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class PostsTools {
  //Map respuesta cancelación de una reservación
  Future<Map> getAdminInfoPosts() async {
    var url = kUrlApi + 'posts/get_admin_info_posts/';
    print(url);
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error solicitar posts de admin');
    }
  }
}
