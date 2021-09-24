import 'package:flutter/material.dart';
import 'dart:async';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:brave_app/Config/validation.dart';
import 'package:brave_app/Accounts/models/account_model.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
// Variables
//--------------------------------------------------------------------------

  Future<Map> _updateResponse;
  bool _loading = false;

  TextEditingController _displayNameController;
  TextEditingController _usernameController;
  TextEditingController _emailController;

  final _updateProfileFormKey = GlobalKey<FormState>();
  final _scaffKey = GlobalKey<ScaffoldState>();

// Obtener datos de usuario por SharedPreferences
//--------------------------------------------------------------------------
  Map<String, String> userInfo = {
    'userId': UserSimplePreferences.getUserId(),
    'displayName': UserSimplePreferences.getUserDisplayName(),
    'username': UserSimplePreferences.getUsername(),
    'email': UserSimplePreferences.getUserEmail(),
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _loadProfileData() async {
    setState(() {
      //Establecer valores en controladores
      _displayNameController =
          TextEditingController(text: userInfo['displayName']);
      _usernameController = TextEditingController(text: userInfo['username']);
      _emailController = TextEditingController(text: userInfo['email']);
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
                SizedBox(height: 16),
                Form(
                  key: _updateProfileFormKey,
                  child: Column(
                    children: [
                      _displayNameField(),
                      SizedBox(height: 15),
                      _userNameField(),
                      SizedBox(height: 15),
                      _emailField(),
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

  Widget _displayNameField() {
    return TextFormField(
      controller: _displayNameController,
      decoration: InputDecoration(
        labelText: 'Nombre',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
    );
  }

  Widget _userNameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Nombre de usuario',
      ),
      validator:
          RequiredValidator(errorText: 'Por favor complete esta casilla'),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
      ),
      validator: kRequiredEmailValidator,
    );
  }

// Funciones
//--------------------------------------------------------------------------

  //Realizar la validación de register de usuario
  void _validateFormSend(BuildContext context) {
    setState(() => _loading = true);

    //Validar casillas del formulario
    if (_updateProfileFormKey.currentState.validate()) {
      _updateProfileFormKey.currentState.save();

      //Enviar formulario
      _updateResponse = AccountModel().updateProfile(
        userInfo['userId'],
        {
          'display_name': _displayNameController.text,
          'username': _usernameController.text,
          'email': _emailController.text,
        },
      );

      //Al recibir respuesta
      _updateResponse.then(
        (updateData) {
          setState(() => _loading = false);

          if (updateData['status'] == 1) {
            _updateSharedPreferences();
            _showSuccessSnackBar(context);
            Navigator.of(context).pop();
          } else {
            print('Error en la actualización');
            _showValidationErrorDialog(updateData['validation_data']);
          }
        },
      );
    }
  }

  //Actualizar datos de cuenta de usuario en SharedPreferences
  void _updateSharedPreferences() async {
    UserSimplePreferences.setUserDisplayName(_displayNameController.text);
    UserSimplePreferences.setUserEmail(_emailController.text);
    UserSimplePreferences.setUsername(_usernameController.text);
  }

  //Mostrar diálogo con error de validación
  void _showValidationErrorDialog(validationData) {
    setState(() {});

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Información',
          style: TextStyle(color: Colors.redAccent),
        ),
        content: Text(validationData['error']),
      ),
    );
  }

  // Mostrar SnackBar con resultado de actualización de datos en BackEnd
  void _showSuccessSnackBar(context) {
    SnackBar snackBar = SnackBar(
      content: Text('Cambios guardados'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
