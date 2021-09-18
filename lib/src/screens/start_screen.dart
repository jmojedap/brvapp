import 'package:flutter/material.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/User/models/user_tools.dart';

class StartScreen extends StatefulWidget {
  //const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String _userId = UserSimplePreferences.getUserId();
  //String _userKey = UserSimplePreferences.getUserKey();
  Future _futureUserKey;

// Herramientas
//--------------------------------------------------------------------------
  UserTools userTools = UserTools();

  @override
  void initState() {
    super.initState();
    //_checkSession();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _checkSession() async {
    print('Checking session');

    print(_userId);
    if (_userId == '0') {
      _goToNextScreen('/login');
    } else {
      /*if (_userKey == '0') {
        getUserKey();
      }*/
      _goToNextScreen('/admin_info_posts_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(66.0),
            child: Image.asset('assets/img/logo-400.png'),
          ),
          ElevatedButton(
            onPressed: () {
              //_goToNextScreen('/login');
              _checkSession();
            },
            child: Text('Continuar'),
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

  /* Cargar datos de usuario de SharedPreferences */
  void getUserKey() async {
    _futureUserKey = userTools.getUserKey(_userId);

    _futureUserKey.then((mapResponse) {
      print(mapResponse);
      setState(() {});
    });
  }
}
