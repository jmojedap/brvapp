import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  //const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(56.0),
            child: Image.asset('assets/img/logo-400.png'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
