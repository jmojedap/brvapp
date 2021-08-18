import 'package:flutter/material.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:brave_app/User/models/user_tools.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
// Herramientas
//--------------------------------------------------------------------------
  UserTools userTools = UserTools();

// Variables
//--------------------------------------------------------------------------
  bool loading = true;
  Future<Map> futureUserInfo;
  Map userInfo = {
    'userId': '0',
    'displayName': '',
    'username': '',
    'email': '',
    'picture': kDefaultUserPicture,
    'expirationAt': ''
  };

  DateTime expirationAt;

// Building
//------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void getUserInfo() async {
    //Cargar variable userInfo
    userInfo['userId'] = UserSimplePreferences.getUserId();
    userInfo['email'] = UserSimplePreferences.getUserEmail();
    userInfo['displayName'] = UserSimplePreferences.getUserDisplayName();
    userInfo['picture'] = UserSimplePreferences.getUserPicture();

    futureUserInfo = userTools.getInfo(userInfo['userId'], 'general');

    futureUserInfo.then((mapResponse) {
      loading = false;
      Map mapUser = mapResponse['user'];
      userInfo['expirationAt'] = mapUser['expiration_at'];
      if (userInfo['expirationAt'] != null) {
        print(userInfo['expirtationAt']);
        expirationAt = DateTime.parse(mapUser['expiration_at']);
      }
      setBodyContent(context);
      setState(() {});
    });
  }

// Constructor
//--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userInfo['displayName'])),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Center(
          child: setBodyContent(context),
        ),
      ),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(),
    );
  }

  void _goToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, '/profile_edit');
  }

  Widget setBodyContent(context) {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return profileInfo(context);
    }
  }

  Widget profileInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(userInfo['picture']),
          radius: 50,
        ),
        SizedBox(height: 12),
        Text(
          userInfo['displayName'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 12),
        Text(
          userInfo['email'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 15),
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
        SizedBox(height: 12),
        _expirationAtInfo()
      ],
    );
  }

  Widget _expirationAtInfo() {
    if (expirationAt == null) {
      return Column(
        children: [
          Icon(
            Icons.info,
            color: Colors.blue,
            size: 48,
          ),
          SizedBox(height: 12),
          Text('No tienes una suscripción activa'),
          SizedBox(height: 12),
          Text('Contacta a tu asesor comercial'),
        ],
      );
    } else if (expirationAt.isAfter(DateTime.now())) {
      final expirationAgo = timeago.format(
        expirationAt,
        locale: 'es',
        allowFromNow: true,
      );
      return Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 36),
          SizedBox(height: 6),
          Text('Tienes sucripción activa hasta'),
          SizedBox(height: 6),
          Text(expirationAgo),
          SizedBox(height: 6),
          Text(DateFormat.yMMMMEEEEd('es_ES').format(expirationAt)),
        ],
      );
    } else {
      final expirationAgo = timeago.format(
        expirationAt,
        locale: 'es',
        allowFromNow: true,
      );
      return Column(
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.yellow[700], size: 36),
          SizedBox(height: 6),
          Text('Tu suscripción está vencida'),
          SizedBox(height: 6),
          Text(
            expirationAgo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kBgColors['appSecondary'],
            ),
          ),
          SizedBox(height: 6),
          Text(DateFormat.yMMMMEEEEd('es_ES').format(expirationAt)),
          SizedBox(height: 6),
          Text('Contacta a tu asesor comercial para renovarla'),
        ],
      );
    }
  }
}
