import 'package:flutter/material.dart';
import 'dart:async';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Accounts/models/account_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
// Variables
//--------------------------------------------------------------------------
  Future<Map> _futureValidation;
  bool _loading = false;

  String _emailValue;
  String _passwordValue;

  final _loginFormKey = GlobalKey<FormState>();

// Builder
//--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 36, bottom: 18),
                child: Image.asset('assets/img/logo-400.png'),
              ),
              Container(
                child: Form(
                  key: _loginFormKey,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(18),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
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
        ),
      ),
    );
  }

// Widgets
//--------------------------------------------------------------------------

  //Campo correo electrónico
  Widget _emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
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
          if (_loading) _loadingIndicator(),
          Text('Iniciar sesión'),
        ],
      ),
    );
  }

  //Indica proceso de cargue cuando se está validando datos de login
  Widget _loadingIndicator() {
    return Container(
      height: 15,
      width: 15,
      margin: EdgeInsets.only(right: 10),
      child: CircularProgressIndicator(
        color: Colors.white,
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
      _futureValidation =
          AccountModel().validateLogin(_emailValue, _passwordValue);

      //Al recibir respuesta de validación
      _futureValidation.then(
        (validationData) {
          if (validationData['status'] == 1) {
            _loadSharedPreferences(validationData['user_info']);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/admin_info_posts_screen', (route) => false);
          } else {
            _showInvalidLoginDialog(validationData);
          }
        },
      );
    }
  }

  //Ir a la pantalla de registro
  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
  }

  //Establecer datos de cuenta de usuario en SharedPreferences
  void _loadSharedPreferences(userInfo) async {
    await UserSimplePreferences.setUserId(userInfo['user_id']);
    await UserSimplePreferences.setUserKey(userInfo['userkey']);
    await UserSimplePreferences.setUserIK(
        userInfo['user_id'], userInfo['userkey']);
    await UserSimplePreferences.setUserDisplayName(userInfo['display_name']);
    await UserSimplePreferences.setUsername(userInfo['username']);
    await UserSimplePreferences.setUserEmail(userInfo['email']);
    await UserSimplePreferences.setUserPicture(userInfo['picture']);
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
