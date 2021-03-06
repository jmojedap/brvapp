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
      body: SingleChildScrollView(
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
    );
  }

// Widgets
//--------------------------------------------------------------------------
  //Campo displayName
  Widget _displayNameField() {
    return TextFormField(
      initialValue: '',
      //initialValue: 'Tester Pacarina',
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
      //initialValue: 'tester@pacarina.net',
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
        labelText: 'Correo electr??nico',
      ),
    );
  }

  //Campo email
  Widget _documentNumberField() {
    return TextFormField(
      initialValue: '',
      //initialValue: '16073346',
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

  //Campo contrase??a
  Widget _passwordField() {
    return TextFormField(
      initialValue: '',
      //initialValue: 'brave2021',
      onSaved: (value) {
        _passwordValue = value;
      },
      validator: kPasswordValidator,
      decoration: InputDecoration(labelText: 'Contrase??a'),
      obscureText: true,
    );
  }

  //Casilla de verificaci??n, aceptaci??n de t??rminos y condiciones
  Widget _checkboxTermsTile() {
    return CheckboxListTile(
      title: const Text(
        'Conozco y acepto la pol??tica de tratamiento de datos personales de Brave',
        style: TextStyle(fontSize: 12),
      ),
      subtitle: _checkboxTermsTileSubtitle(),
      value: _acceptedTerms,
      onChanged: (bool value) {
        setState(() => _acceptedTerms = value);
      },
    );
  }

  /// Subt??tulo de casilla de aceptaci??n de t??rminos
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
      child: Text('Ver pol??tica', style: TextStyle(color: Colors.blue)),
    );
  }

  //Bot??n env??o formulario
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () => _register(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_loading) _loadingIndicator(),
          Text('Crear cuenta'),
        ],
      ),
    );
  }

  //Indica proceso de cargue cuando se est?? validando datos de login
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

  Widget _bottomInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('??Ya tienes una cuenta?'),
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

  /// Realizar la validaci??n de register de usuario
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

      //Al recibir respuesta de validaci??n
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

  //Mostrar di??logo con error de validaci??n
  void _showInvalidSignUpDialog(validationData) {
    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Creaci??n de cuenta',
          style: TextStyle(color: Colors.lightBlue),
        ),
        content: Text(_errorText(validationData['validation'])),
      ),
    );
  }

  //Texto para mostrar en el Dialog seg??n el error
  String _errorText(validation) {
    //print(validation);
    if (validation['email_unique'] == 0) {
      return 'Ya existe un usuario con este correo electr??nico.';
    }
    if (validation['document_number_unique'] == 0) {
      return 'Ya existe un usuario con este n??mero de documento.';
    }
    return 'Ocurri?? un error al crear la cuenta';
  }
}
