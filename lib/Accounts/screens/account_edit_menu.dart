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
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Foto de perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/user_picture');
              },
            ),
            ListTile(
              leading: Icon(Icons.one_x_mobiledata_outlined),
              title: Text('Número de documento'),
              onTap: () {
                Navigator.pushNamed(context, '/edit_document');
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
