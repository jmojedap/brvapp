import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<int> _loginValidation;
  bool _loading = false;

  String _emailValue;
  String _passwordValue;

  final _loginFormKey = GlobalKey<FormState>();

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
            child: Form(
              key: _loginFormKey,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 180, bottom: 20),
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
          ),
        ],
      ),
    );
  }

// Widgets
//--------------------------------------------------------------------------

  Widget _emailField() {
    return TextFormField(
      onSaved: (value) {
        _emailValue = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
      onSaved: (value) {
        _passwordValue = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
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

// Funciones
//--------------------------------------------------------------------------

  void _login(BuildContext context) {
    //Aún no se ha enviado
    if (!_loading) {
      //Validar formulario
      if (_loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();

        _loginValidation = _validateLogin();

        _loginValidation.then((value) => {print('Value: ' + value.toString())});

        setState(() {
          _loading = true;
        });
      }
    }
    /*Navigator.of(context)
        .pushNamedAndRemoveUntil('/posts_feed_screen', (route) => false);*/
  }

  Future<int> _validateLogin() async {
    print(_emailValue);
    print(_passwordValue);

    var urlUsers =
        Uri.parse('https://www.bravebackend.com/api/accounts/validate_login/');
    var response = await http.post(
      urlUsers,
      body: {
        'username': _emailValue,
        'password': _passwordValue,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      return response.statusCode;
    } else {
      throw Exception('Error al solicitar listado de usuarios');
    }
  }

  //Ir a la pantalla de registro
  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
  }
}
