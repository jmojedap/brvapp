import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/src/models/Publicacion.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PostsFeedScreen extends StatefulWidget {
  //PostsFeedScreen({Key? key}) : super(key: key);

  @override
  _PostsFeedScreenState createState() => _PostsFeedScreenState();
}

class _PostsFeedScreenState extends State<PostsFeedScreen> {
  Future<List> futurePublicaciones;

  @override
  void initState() {
    super.initState();
    futurePublicaciones = _getPublicaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brave'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 24),
        child: FutureBuilder(
          future: futurePublicaciones,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listPublicaciones(snapshot.data),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(),
    );
  }

  Future<List<Publicacion>> _getPublicaciones() async {
    const String urlPublicaciones = 'https://bravebackend.com/api/posts/get';
    final response = await http.get(Uri.parse(urlPublicaciones));

    List<Publicacion> objPublicaciones = [];

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['list']) {
        objPublicaciones.add(Publicacion.fromJson(item));
      }

      return objPublicaciones;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Publicacion');
    }
  }

  List<Widget> _listPublicaciones(data) {
    List<Widget> publicaciones = [];

    for (var item in data) {
      publicaciones.add(_publicacion(item));
    }

    return publicaciones;
  }

  Widget _publicacion(item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/img/lina.jpg'),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Lina López',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        FadeInImage.assetNetwork(
          placeholder: 'assets/img/loading.gif',
          image: item.urlImage,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 30,
              ),
              SizedBox(width: 12),
              Icon(
                Icons.comment_bank_outlined,
                size: 30,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}