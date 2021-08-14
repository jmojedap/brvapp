import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  //const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String _userId = '';
  //String _routeDestination = '/login';

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _checkSession() async {
    print('Check Session');
    final prefs = await SharedPreferences.getInstance();
    _userId = (prefs.getString('userDisplayName') ?? '');
    if (_userId == '') {
      _goToNextScreen('/login');
    } else {
      _goToNextScreen('/calendar_screen');
    }
  }

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
        ],
      ),
    );
  }

  void _goToNextScreen(String destinationRoute) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      destinationRoute,
      (route) => false,
    );
  }
}
