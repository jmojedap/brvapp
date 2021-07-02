import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(72.0),
            child: Image.asset('assets/img/logo-400.png'),
          ),
          Center(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 180,
                bottom: 20,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _emailField(),
                      _passwordField(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 20),
                      _bottomInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () => {_login(context)},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_loading)
            Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.only(right: 20),
              child: CircularProgressIndicator(),
            ),
          Text('Iniciar sesión'),
        ],
      ),
    );
  }

  Widget _bottomInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('¿No estás registrado?'),
        TextButton(
          onPressed: () => {
            _showRegister(context),
          },
          child: Text('Registrarme'),
        ),
      ],
    );
  }

  void _login(BuildContext context) {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/posts_feed_screen', (route) => false);
  }

  //Ir a la pantalla de registro
  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
  }
}
