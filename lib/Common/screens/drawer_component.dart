import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

class DrawerComponent extends StatefulWidget {
  //const DrawerComponent({Key? key}) : super(key: key);

  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  Map<String, String> _userInfo = {
    'displayName': UserSimplePreferences.getUserDisplayName(),
    'email': UserSimplePreferences.getUserEmail(),
    'picture': UserSimplePreferences.getUserPicture(),
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_userInfo['displayName']),
            accountEmail: Text(_userInfo['email']),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_userInfo['picture']),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: Text('InBody'),
            leading: Icon(Icons.run_circle_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/inbody');
            },
          ),
          ListTile(
            title: Text('Acerca de Brave App'),
            leading: Icon(Icons.info_outline),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/about');
            },
          ),
          ListTile(
            title: Text('Salir'),
            leading: Icon(Icons.logout),
            onTap: () => _clearSharedPreferences(context),
          ),
        ],
      ),
    );
  }

  /*void _showHome(BuildContext context) {
    print('Probando impresión de textos');
    Navigator.pop(context);
  }*/

  /// Limpiar datos de usuario de SharedPreferences e ir a inicio
  /// 2021-07-13
  void _clearSharedPreferences(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
