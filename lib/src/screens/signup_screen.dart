import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset('assets/img/logo-400.png'),
            padding: const EdgeInsets.all(72.0),
          ),
          Center(
            child: SingleChildScrollView(
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _displayNameField(),
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

  Widget _displayNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Tu nombre',
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
          Text('Crear cuenta'),
        ],
      ),
    );
  }

  Widget _bottomInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('¿Ya tienes una cuenta?'),
        TextButton(
          onPressed: () => {
            _showLogin(context),
          },
          child: Text('Ingresar'),
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
    Navigator.of(context).pushNamedAndRemoveUntil('/profile', (route) => false);
  }

  //Ir a la pantalla de registro
  void _showLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
