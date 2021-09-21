import 'package:brave_app/Follow/models/FollowerModel.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/Common/screens/bottom_bar_component.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class FollowersScreen extends StatefulWidget {
  //FollowersScreen({Key? key}) : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  Future<List> futureFollowers;
  Future<List> futureFollowing;

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
    futureFollowers = _getFollowers();
    futureFollowing = _getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('lina_lopez'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('18 seguidores')),
              Tab(child: Text('135 seguidos')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _followersListView(),
            _followingListView(),
          ],
        ),
        bottomNavigationBar: BottomBarComponent(0),
      ),
    );
  }

// SEGUIDORES
//--------------------------------------------------------------------------

  //Función de solicitud de JSON seguidores
  Future<List<Follower>> _getFollowers() async {
    const String urlFollowers =
        'https://www.bravebackend.com/api/follow/get_followers/202019';
    final response = await http.get(Uri.parse(urlFollowers));

    List<Follower> objFollowers = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['users']) {
        objFollowers.add(Follower.fromJson(item));
      }

      return objFollowers;
    } else {
      throw Exception('Error al solicitar listado de seguidores');
    }
  }

  //ListView de seguidores
  Widget _followersListView() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: FutureBuilder(
        future: futureFollowers,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _followersList(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // Por defecto devolver indicador de proceso de carga
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  //Lista con Widgets de seguidores
  List<Widget> _followersList(data) {
    List<Widget> followers = [];

    for (var item in data) {
      followers.add(_follower(item));
    }

    return followers;
  }

  //Widget seguidor
  Widget _follower(item) {
    return ListTile(
      leading: _circleAvatarFollower(item),
      title: Text(item.userName),
      subtitle: Text(item.displayName, style: TextStyle(color: Colors.black45)),
      trailing: ElevatedButton(
        child: Text('Eliminar', style: TextStyle(color: Colors.black87)),
        onPressed: () {
          print('Eliminando item');
        },
        style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
    );
  }

// SEGUIDOS
//--------------------------------------------------------------------------

  //Función de solicitud de JSON seguidores
  Future<List<Follower>> _getFollowing() async {
    const String urlFollowing =
        'https://www.bravebackend.com/api/follow/get_following/202019';
    final response = await http.get(Uri.parse(urlFollowing));

    List<Follower> objFollowing = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['users']) {
        objFollowing.add(Follower.fromJson(item));
      }

      return objFollowing;
    } else {
      throw Exception('Error al solicitar listado de seguidores');
    }
  }

  //ListView de seguidores
  Widget _followingListView() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: FutureBuilder(
        future: futureFollowing,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _followingList(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // Por defecto devolver indicador de proceso de carga
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  //Lista con Widgets de seguidores
  List<Widget> _followingList(data) {
    List<Widget> following = [];

    for (var item in data) {
      following.add(_following(item));
    }

    return following;
  }

  //Widget seguidor
  Widget _following(item) {
    return ListTile(
      leading: _circleAvatarFollower(item),
      title: Text(item.userName),
      subtitle: Text(item.displayName, style: TextStyle(color: Colors.black45)),
      trailing: ElevatedButton(
        child: Text('Siguiendo', style: TextStyle(color: Colors.black87)),
        onPressed: () {
          print('Eliminando item');
        },
        style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
    );
  }

  Widget _circleAvatarFollower(item) {
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
}
