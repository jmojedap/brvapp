import 'dart:convert';
import 'package:brave_app/Config/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PostsTools {
  //Map respuesta cancelación de una reservación
  Future<List> getAdminInfoPosts() async {
    var url = Uri.parse(kUrlApi + 'posts/get_admin_info_posts/');
    print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final mapResponse = jsonDecode(response.body);
      print(mapResponse);
      return mapResponse['posts'];
    } else {
      throw Exception('Error solicitar posts de admin');
    }
  }
}
