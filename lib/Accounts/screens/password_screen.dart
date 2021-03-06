import 'package:flutter/material.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Accounts/models/account_model.dart';
import 'package:brave_app/Config/validation.dart';
import 'dart:async';
import 'package:form_field_validator/form_field_validator.dart';

class PasswordScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
// Variables
//--------------------------------------------------------------------------

  Future<Map> _updateResponse;
  bool _loading = false;

  TextEditingController _currentPasswordController;
  TextEditingController _newPasswordController;
  TextEditingController _newPasswordConfirmationController;

  final _changePasswordFormKey = GlobalKey<FormState>();
  final _scaffKey = GlobalKey<ScaffoldState>();

// Obtener datos de usuario por SharedPreferences
//--------------------------------------------------------------------------
  String userId = '';
  //Map<String, String> userInfo = {'userId': ''};

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _loadProfileData() async {
    setState(() {
      userId = UserSimplePreferences.getUserId();

      //Establecer valores en controladores
      _currentPasswordController = TextEditingController();
      _newPasswordController = TextEditingController();
      _newPasswordConfirmationController = TextEditingController();
    });
  }

// Constructor
//--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buttonsTop(context),
                SizedBox(height: 6),
                Form(
                  key: _changePasswordFormKey,
                  child: Column(
                    children: [
                      _currentPasswordField(),
                      SizedBox(height: 18),
                      _newPasswordField(),
                      SizedBox(height: 18),
                      _newPasswordConfirmationField(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Widgets
//--------------------------------------------------------------------------

  Widget _buttonsTop(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.close, color: Colors.black54),
          onPressed: () => {Navigator.pop(context)},
          iconSize: 42,
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: kBgColors['appDark'],
          ),
          onPressed: () {
            _validateFormSend(context);
          },
          iconSize: 42,
        ),
      ],
    );
  }

  Widget _currentPasswordField() {
    return TextFormField(
      enabled: !_loading,
      obscureText: true,
      controller: _currentPasswordController,
      decoration: InputDecoration(
        labelText: 'Contrase??a actual',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
    );
  }

  Widget _newPasswordField() {
    return TextFormField(
      enabled: !_loading,
      obscureText: true,
      controller: _newPasswordController,
      decoration: InputDecoration(
        labelText: 'Contrase??a nueva',
      ),
      validator: kPasswordValidator,
    );
  }

  Widget _newPasswordConfirmationField() {
    return TextFormField(
      enabled: !_loading,
      obscureText: true,
      controller: _newPasswordConfirmationController,
      decoration: InputDecoration(
        labelText: 'Repetir contrase??a nueva',
      ),
      validator:
          RequiredValidator(errorText: 'Por favor complete esta casilla'),
    );
  }

// Funciones
//--------------------------------------------------------------------------

  //Realizar la validaci??n de register de usuario
  void _validateFormSend(BuildContext context) {
    setState(() => _loading = true);

    //Validar casillas del formulario
    if (_changePasswordFormKey.currentState.validate()) {
      _changePasswordFormKey.currentState.save();

      //Enviar formulario
      _updateResponse = AccountModel().changePassword(
        userId,
        {
          'current_password': _currentPasswordController.text,
          'password': _newPasswordController.text,
          'passconf': _newPasswordConfirmationController.text,
        },
      );

      //Al recibir respuesta
      _updateResponse.then(
        (responseBody) {
          setState(() => _loading = false);
          if (responseBody['status'] == 1) {
            _showSuccessSnackBar(context);
            Navigator.of(context).pop();
          } else {
            _showValidationErrorDialog(responseBody['error']);
          }
        },
      );
    }
  }

  //Mostrar di??logo con error de validaci??n
  void _showValidationErrorDialog(errorText) {
    setState(() {});

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Informaci??n',
          style: TextStyle(color: Colors.redAccent),
        ),
        content: Text(errorText),
      ),
    );
  }

  // Mostrar SnackBar con resultado de actualizaci??n de datos en BackEnd
  void _showSuccessSnackBar(context) {
    SnackBar snackBar = SnackBar(
      content: Text('Contrase??a modificada'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
