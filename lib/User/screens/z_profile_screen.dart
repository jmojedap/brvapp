import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
// Variables
//--------------------------------------------------------------------------
  Future<Map> _followInfo;

  final TextStyle _counterStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

// Obtener datos de usuario por SharedPreferences
//--------------------------------------------------------------------------
  Map<String, String> _userInfo = {
    'userId': '0',
    'displayName': '',
    'username': '',
    'email': '',
    'qtyFollowers': '',
    'qtyFollowing': '',
    'qtyPosts': '',
    'picture': kDefaultUserPicture,
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _loadProfileData() async {
    //Cargar variable userInfo
    _userInfo['userId'] = UserSimplePreferences.getUserId();
    _userInfo['displayName'] = UserSimplePreferences.getUserDisplayName();
    _userInfo['picture'] = UserSimplePreferences.getUserPicture();
    print('userId: ' + _userInfo['userId']);

    //Requerir datos de Follow del usuario desde API
    print(_userInfo['userId']);
    _followInfo = _getFollowInfo(_userInfo['userId']);

    _followInfo.then((response) {
      _userInfo['qtyFollowers'] = response['user']['qty_followers'];
      _userInfo['qtyFollowing'] = response['user']['qty_following'];
      _userInfo['qtyPosts'] = response['user']['qty_posts'];

      setState(() {
        print('Cargando info de usuario');
      });
    });
  }

// Constructor
//--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_userInfo['displayName'])),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: _profileInfo(context),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: ElevatedButton(
              onPressed: () => {_goToProfileEdit(context)},
              child: Text(
                'Editar perfil',
                style: TextStyle(color: Colors.black87),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
          Flexible(
            child: _postsGrid,
          ),
        ],
      ),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(2),
    );
  }

  void _goToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, '/profile_edit');
  }

  Widget _profileInfo(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(_userInfo['picture']),
              radius: 50,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Text(
                _userInfo['displayName'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              width: 130,
            ),
          ],
        ),
        InkWell(
          onTap: () {
            print('abriendo publicacioens');
          },
          child: Column(
            children: [
              Text(_userInfo['qtyPosts'], style: _counterStyle),
              Text('Publicaci...'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/follow_followers');
          },
          child: Column(
            children: [
              Text(
                _userInfo['qtyFollowers'],
                style: _counterStyle,
              ),
              Text('Seguidor...'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/follow_followers');
          },
          child: Column(
            children: [
              Text(_userInfo['qtyFollowing'], style: _counterStyle),
              Text('Seguidos'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _postsGrid = GridView.count(
    crossAxisSpacing: 2,
    mainAxisSpacing: 2,
    crossAxisCount: 3,
    children: <Widget>[
      Container(
        child: Image.asset('assets/examples/sm_post_01.png'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_02.png'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_03.jpg'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_04.jpg'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_05.png'),
      ),
    ],
  );

// Funciones
//--------------------------------------------------------------------------

  //Solicitud de información de following del usuario
  Future<Map> _getFollowInfo(String userId) async {
    print(userId);
    var url =
        Uri.parse(kUrlApi + 'accounts/profile_info/' + userId + '/general');
    print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al requerir información de usuario');
    }
  }
}
