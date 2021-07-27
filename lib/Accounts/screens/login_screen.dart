import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
// Variables
//--------------------------------------------------------------------------
  Future<Map> _loginValidation;
  bool _loading = false;

  String _emailValue;
  String _passwordValue;

  final _loginFormKey = GlobalKey<FormState>();

// Builder
//--------------------------------------------------------------------------
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

  //Campo correo electrónico
  Widget _emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      //initialValue: 'linalop@pacarina.net',
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

  //Campo contraseña
  Widget _passwordField() {
    return TextFormField(
      //initialValue: 'brave2021',
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

  //Botón envío formulario
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
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.green[50]),
                child: new CircularProgressIndicator(),
              ),
            ),
          Text('Iniciar sesión'),
        ],
      ),
    );
  }

  //Información bajo formulario
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

  //Realizar la validación de login de usuario
  void _login(BuildContext context) {
    setState(() {
      _loading = true;
    });

    //Validar casillas del formulario
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      //Validar login
      _loginValidation = _validateLogin();

      //Al recibir respuesta de validación
      _loginValidation.then(
        (validationData) {
          /*print('Login validation status: ' +
              validationData['status'].toString());*/
          if (validationData['status'] == 1) {
            _loadSharedPreferences(validationData);
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/profile', (route) => false);
          } else {
            _showInvalidLoginDialog(validationData);
          }
        },
      );
    }
  }

  //Enviar datos de formulario y recibir datos de validación
  Future<Map> _validateLogin() async {
    var urlUsers =
        Uri.parse('https://www.bravebackend.com/api/accounts/validate_login/');
    var response = await http.post(
      urlUsers,
      body: {'username': _emailValue, 'password': _passwordValue},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al solicitar listado de usuarios');
    }
  }

  //Ir a la pantalla de registro
  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
  }

  //Establecer datos de cuenta de usuario en SharedPreferences
  void _loadSharedPreferences(validationData) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
        'userDisplayName', validationData['user_info']['display_name']);
    prefs.setString('userId', validationData['user_info']['user_id']);
    prefs.setString('userEmail', validationData['user_info']['email']);

    String defaultUserPicture =
        'https://www.bravebackend.com/resources/static/images/users/user.png';
    if (validationData['user_info']['picture'].length > 0) {
      prefs.setString('userPicture', validationData['user_info']['picture']);
    } else {
      prefs.setString('userPicture', defaultUserPicture);
    }
  }

  //Mostrar diálogo con error de validación
  void _showInvalidLoginDialog(validationData) {
    setState(() {
      _loading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Inicio de sesión',
          style: TextStyle(color: Colors.lightBlue),
        ),
        content: Text(validationData['messages'].join('. ')),
      ),
    );
  }
}
