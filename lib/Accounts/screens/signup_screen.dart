import 'package:flutter/material.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Config/validation.dart';
import 'dart:async';
import 'package:brave_app/Accounts/screens/user_data_terms_screen.dart';
import 'package:brave_app/Accounts/models/account_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
// Variables
//--------------------------------------------------------------------------
  Future<Map> _futureSignUp;
  bool _loading = false;

  String _emailValue;
  String _displayNameValue;
  String _documentNumberValue;
  String _passwordValue;
  bool _acceptedTerms = false;
  bool _acceptedTermsValidator = true;

  final _registerFormKey = GlobalKey<FormState>();

// Builder
//--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 36),
            height: 120,
            child: Center(
              child: Image.asset('assets/img/logo-400.png'),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _registerFormKey,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 100, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _displayNameField(),
                        _emailField(),
                        _documentNumberField(),
                        _passwordField(),
                        SizedBox(height: 9),
                        _checkboxTermsTile(),
                        _linkTermsScreen(),
                        SizedBox(height: 9),
                        _submitButton(),
                        SizedBox(height: 9),
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
      decoration: InputDecoration(labelText: 'Nombre completo'),
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

  //Campo email
  Widget _documentNumberField() {
    return TextFormField(
      initialValue: '',
      keyboardType: TextInputType.number,
      onSaved: (value) {
        _documentNumberValue = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'No. documento',
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
      validator: kPasswordValidator,
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
    );
  }

  //Casilla de verificación, aceptación de términos y condiciones
  Widget _checkboxTermsTile() {
    return CheckboxListTile(
      title: const Text(
        'Conozco y acepto la política de tratamiento de datos personales de Brave',
        style: TextStyle(fontSize: 12),
      ),
      subtitle: _checkboxTermsTileSubtitle(),
      value: _acceptedTerms,
      onChanged: (bool value) {
        setState(() => _acceptedTerms = value);
      },
    );
  }

  /// Subtítulo de casilla de aceptación de términos
  Widget _checkboxTermsTileSubtitle() {
    if (_acceptedTermsValidator == false) {
      return Text(
        'Para continuar debes activar esta casilla',
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      );
    }
    return SizedBox();
  }

  Widget _linkTermsScreen() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDataTerms(),
          ),
        );
      },
      child: Text('Ver política', style: TextStyle(color: Colors.blue)),
    );
  }

  //Botón envío formulario
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () => _register(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_loading) CircularProgressIndicator(color: Colors.green[50]),
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

  /// Realizar la validación de register de usuario
  void _register(BuildContext context) {
    //Validar casillas del formulario
    setState(() {
      _acceptedTermsValidator = _acceptedTerms;
      _checkboxTermsTileSubtitle();
    });

    if (_registerFormKey.currentState.validate() && _acceptedTerms) {
      _registerFormKey.currentState.save();

      setState(() => _loading = true);

      var formData = {
        'display_name': _displayNameValue,
        'email': _emailValue,
        'document_number': _documentNumberValue,
        'new_password': _passwordValue,
      };

      //Enviar SignUp
      _futureSignUp = AccountModel().signUp(formData);

      //Al recibir respuesta de validación
      _futureSignUp.then(
        (signUpResponse) {
          print('Register signUpResponse');
          print(signUpResponse);
          if (signUpResponse['status'] == 1) {
            _loadSharedPreferences(signUpResponse['user_info']);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/admin_info_posts_screen', (route) => false);
          } else {
            _showInvalidSignUpDialog(signUpResponse['validation_data']);
          }
        },
      );
    }
  }

  /// Ir a la pantalla de login
  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  /// Establecer datos de cuenta de usuario en SharedPreferences
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
  void _showInvalidSignUpDialog(validationData) {
    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Creación de cuenta',
          style: TextStyle(color: Colors.lightBlue),
        ),
        content: Text(_errorText(validationData['validation'])),
      ),
    );
  }

  //Texto para mostrar en el Dialog según el error
  String _errorText(validation) {
    //print(validation);
    if (validation['email_unique'] == 0) {
      return 'Ya existe un usuario con este correo electrónico.';
    }
    if (validation['document_number_unique'] == 0) {
      return 'Ya existe un usuario con este número de documento.';
    }
    return 'Ocurrió un error al crear la cuenta';
  }
}
