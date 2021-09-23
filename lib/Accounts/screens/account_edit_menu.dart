import 'package:flutter/material.dart';

class AccountEditMenu extends StatelessWidget {
  //const AccountEditMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Editar')),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile_edit');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin_rounded),
              title: Text('Foto de perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/user_picture');
              },
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Contraseña'),
              onTap: () {
                Navigator.pushNamed(context, '/password');
              },
            ),
          ],
        ),
      ),
    );
  }
}
