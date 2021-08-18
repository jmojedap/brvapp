import 'package:flutter/material.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
// Variables
//--------------------------------------------------------------------------
  Future<Map> _registerResponse;
  bool _loading = false;

  String _emailValue;
  String _displayNameValue;
  String _passwordValue;

  final _registerFormKey = GlobalKey<FormState>();

// Builder
//--------------------------------------------------------------------------
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
              child: Form(
                key: _registerFormKey,
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
          ),
        ],
      ),
    );
  }

// Widgets
//--------------------------------------------------------------------------
  //Campo displayName
  Widget _displayNameField() {
    return TextFormField(
      initialValue: '',
      onSaved: (value) {
        _displayNameValue = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Tu nombre',
      ),
    );
  }

  //Campo email
  Widget _emailField() {
    return TextFormField(
      initialValue: '',
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
      initialValue: '',
      onSaved: (value) {
        _passwordValue = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
    );
  }

  //Botón envío formulario
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () => {_register(context)},
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
            _goToLogin(context),
          },
          child: Text('Ingresar'),
        ),
      ],
    );
  }

// Funciones
//--------------------------------------------------------------------------

  //Realizar la validación de register de usuario
  void _register(BuildContext context) {
    setState(() {
      _loading = true;
    });

    //Validar casillas del formulario
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();

      //Validar register
      _registerResponse = _sendRegister();

      //Al recibir respuesta de validación
      _registerResponse.then(
        (registerData) {
          print('Register response');
          print(registerData);
          if (registerData['status'] == 1) {
            _loadSharedPreferences(registerData['user_info']);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/admin_info_posts_screen', (route) => false);
            print('PUSHING PROFILE');
          } else {
            _showInvalidLoginDialog(registerData['validation_data']);
          }
        },
      );
    }
  }

  //Enviar datos de formulario y recibir datos de validación
  Future<Map> _sendRegister() async {
    var urlUsers = Uri.parse(kUrlApi + 'accounts/register/');
    var response = await http.post(
      urlUsers,
      body: {
        'display_name': _displayNameValue,
        'email': _emailValue,
        'new_password': _passwordValue
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  //Ir a la pantalla de login
  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  //Establecer datos de cuenta de usuario en SharedPreferences
  void _loadSharedPreferences(userInfo) async {
    await UserSimplePreferences.setUserId(userInfo['user_id']);
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
        content: Text(_errorText(validationData['validation'])),
      ),
    );
  }

  //Texto para mostrar en el Dialog según el error
  String _errorText(validation) {
    print(validation);
    if (validation['email_unique'] == 0) {
      return 'Ya existe una cuenta con este correo electrónico';
    }
    return 'Ocurrió un error al crear la cuenta';
  }
}
