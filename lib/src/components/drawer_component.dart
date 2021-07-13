import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerComponent extends StatefulWidget {
  //const DrawerComponent({Key? key}) : super(key: key);

  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  //TODO: Actualizar url por defecto
  Map<String, String> _userInfo = {
    'userId': '',
    'dislayName': '',
    'email': '',
    'picture':
        'https://www.bravebackend.com/resources/20210516/images/users/user.png',
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
      _userInfo['picture'] = prefs.getString('userPicture');
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
            title: Text('Inicio'),
            leading: Icon(Icons.home),
            onTap: () => _showHome(context),
          ),
          ListTile(
            title: Text('Mi suscripción'),
            leading: Icon(Icons.payment),
            onTap: () => {
              Navigator.of(context).pushNamed('/subscription_status'),
            },
          ),
          ListTile(
            title: Text('Calendario'),
            leading: Icon(Icons.calendar_today),
            onTap: () => {
              Navigator.of(context).pushNamed('/calendar_screen'),
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

  void _showHome(BuildContext context) {
    print('Probando impresión de textos');
    Navigator.pop(context);
  }

  /*
  Limpiar datos de usuario de SharedPreferences e ir a inicio
  2021-07-13 
  */
  void _clearSharedPreferences(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    Navigator.of(context).pushNamed('/start');
  }
}
