import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brave_app/Config/constants.dart';

class DrawerComponent extends StatefulWidget {
  //const DrawerComponent({Key? key}) : super(key: key);

  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  Map<String, String> _userInfo = {
    'userId': '',
    'displayName': '',
    'email': '',
    'picture': kDefaultUserPicture,
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userInfo['displayName'] = (prefs.getString('userDisplayName') ?? '');
      _userInfo['email'] = (prefs.getString('userEmail') ?? '');
      _userInfo['picture'] =
          (prefs.getString('userPicture') ?? kDefaultUserPicture);
    });
  }

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
            title: Text('Contraseña'),
            leading: Icon(Icons.vpn_key),
            onTap: () => {
              Navigator.of(context).pushNamed('/password'),
            },
          ),
          ListTile(
            title: Text('Desempeño'),
            leading: Icon(Icons.vpn_key),
            onTap: () => {
              Navigator.of(context).pushNamed('/performance'),
            },
          ),
          /*ListTile(
            title: Text('Calendario'),
            leading: Icon(Icons.calendar_today),
            onTap: () => {
              Navigator.of(context).pushNamed('/calendar_screen'),
            },
          ),*/
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

  /*
  Limpiar datos de usuario de SharedPreferences e ir a inicio
  2021-07-13 
  */
  void _clearSharedPreferences(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
