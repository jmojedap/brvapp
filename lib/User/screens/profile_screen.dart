import 'package:flutter/material.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/Common/screens/bottom_bar_component.dart';
import 'package:brave_app/Common/screens/drawer_component.dart';
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
    'userId': UserSimplePreferences.getUserId(),
    'displayName': UserSimplePreferences.getUserDisplayName(),
    'email': UserSimplePreferences.getUserEmail(),
    'picture': UserSimplePreferences.getUserPicture(),
    'expirationAt': ''
  };

  DateTime expirationAt = DateTime.now();

// Building
//------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  /// Cargar los datos desde API
  /// 2021-11-11
  void getUserInfo() async {
    futureUserInfo = userTools.getInfo(userInfo['userId'], 'general');

    futureUserInfo.then((mapResponse) {
      loading = false;
      setState(() {});
      Map mapUser = mapResponse['user'];
      userInfo['expirationAt'] = mapUser['expiration_at'];
      if (userInfo['expirationAt'] != null) {
        print('expirationAt:' + userInfo['expirationAt']);
        expirationAt = DateTime.parse(mapUser['expiration_at']);
      }
      setBodyContent(context);
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
      bottomNavigationBar: BottomBarComponent(2),
    );
  }

  void _goToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, '/account_edit_menu');
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
            Icons.info_outline,
            color: Colors.blue,
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            'No tienes una suscripción activa',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
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
