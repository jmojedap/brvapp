import 'package:brave_app/User/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class UsersSearch extends StatefulWidget {
  //UsersSearch({Key? key}) : super(key: key);

  @override
  _UsersSearchState createState() => _UsersSearchState();
}

class _UsersSearchState extends State<UsersSearch> {
  Future<List> futureUsers;

  final List<Color> _avatarColors = [
    Colors.red[700],
    Colors.purple[700],
    Colors.blue[700],
    Colors.yellow[700],
    Colors.orange[700],
    Colors.green[700],
  ];

  @override
  void initState() {
    super.initState();
    //futureUsers = _getUsers();
  }

  //Envía texto de busqueda de usuarios
  void _sendForm(text) {
    futureUsers = _getUsers(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _searchBox(),
            _usersListView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarComponent(2),
    );
  }

// Widgets
//--------------------------------------------------------------------------

  //Casilla de busqueda
  Widget _searchBox() {
    return Container(
      margin: const EdgeInsets.all(12),
      child: TextFormField(
        onChanged: (text) {
          _sendForm(text);
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          hintText: 'Buscar',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  //Widget user
  Widget _user(item) {
    return ListTile(
      leading: _circleAvatarUser(item),
      title: Text(item.userName),
      subtitle: Text(item.displayName, style: TextStyle(color: Colors.black45)),
      trailing: ElevatedButton(
        child: Text('Ver', style: TextStyle(color: Colors.black87)),
        onPressed: () {
          print('Eliminando item');
        },
        style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
    );
  }

  Widget _circleAvatarUser(item) {
    if (item.urlThumbnail.length > 0) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(item.urlThumbnail),
      );
    } else {
      Random random = new Random();
      int _indexColor = random.nextInt(_avatarColors.length);
      return CircleAvatar(
        backgroundColor: _avatarColors[_indexColor],
        radius: 24,
        child: Text(
          item.displayName[0],
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

// Funciones
//--------------------------------------------------------------------------

  //Función de solicitud de JSON usuarios
  Future<List<User>> _getUsers(text) async {
    var urlUsers = Uri.parse('https://www.bravebackend.com/api/users/get/');
    var response = await http.post(urlUsers, body: {'q': text});

    List<User> objUsers = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['list']) {
        objUsers.add(User.fromJson(item));
      }

      return objUsers;
    } else {
      throw Exception('Error al solicitar listado de usuarios');
    }
  }

  //ListView de usuarios
  Widget _usersListView() {
    return Container(
      margin: EdgeInsets.only(top: 64),
      padding: EdgeInsets.only(top: 12),
      child: FutureBuilder(
        future: futureUsers,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _usersList(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // Por defecto devolver indicador de proceso de carga
          return Center(
            //child: CircularProgressIndicator(),
            child: Text('Busca usuarios en Brave'),
          );
        },
      ),
    );
  }

  //Lista con Widgets de usuarios
  List<Widget> _usersList(data) {
    List<Widget> users = [];

    for (var item in data) {
      users.add(_user(item));
    }

    return users;
  }
}
