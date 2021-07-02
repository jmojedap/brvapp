import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  //const DrawerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Lina López'),
            accountEmail: Text('linalop@pacarina.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/img/lina.jpg'),
              backgroundColor: Colors.blue,
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
            onTap: () => {
              Navigator.of(context).pushNamed('/start'),
            },
          ),
        ],
      ),
    );
  }

  void _showHome(BuildContext context) {
    print('Probando impresión de textos');
    Navigator.pop(context);
  }
}
