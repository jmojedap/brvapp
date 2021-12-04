import 'package:flutter/material.dart';
import 'package:brave_app/Config/constants.dart';

class AboutScreen extends StatelessWidget {
  //const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Brave App')),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 180,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 80, bottom: 12),
              child: Image.asset('assets/img/logo-400.png'),
            ),
            Text(
              'Brave App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBgColors['appDark'],
              ),
            ),
            Text(
              'Versión 1.2.1',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        ),
      ),
    ));
  }
}
