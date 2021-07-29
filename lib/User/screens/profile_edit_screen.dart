import 'package:flutter/material.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';

class ProfileEditScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
// Variables
//--------------------------------------------------------------------------

  Future<Map> _updateResponse;
  bool _loading = false;

  TextEditingController _displayNameController;
  TextEditingController _usernameController;
  TextEditingController _emailController;

  final _updateProfileFormKey = GlobalKey<FormState>();

// Obtener datos de usuario por SharedPreferences
//--------------------------------------------------------------------------
  Map<String, String> _userInfo = {
    'userId': '',
    'displayName': 'probando',
    'username': '',
    'email': '',
    'picture': kDefaultUserPicture,
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userInfo['userId'] = (prefs.getString('userId') ?? '0');
      _userInfo['displayName'] = (prefs.getString('userDisplayName') ?? '');
      _userInfo['username'] = (prefs.getString('username') ?? '');
      _userInfo['email'] = (prefs.getString('userEmail') ?? '');
      _userInfo['picture'] =
          (prefs.getString('userPicture') ?? kDefaultUserPicture);

      //Establecer valores en controladores
      _displayNameController =
          TextEditingController(text: _userInfo['displayName']);
      _usernameController = TextEditingController(text: _userInfo['username']);
      _emailController = TextEditingController(text: _userInfo['email']);
    });
  }

// Constructor
//--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                _buttonsTop(context),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/img/lina.jpg'),
                  radius: 50,
                ),
                SizedBox(height: 6),
                Text(
                  'Cambiar foto de perfil',
                  style: TextStyle(fontSize: 18, color: Colors.blue[400]),
                ),
                Form(
                  key: _updateProfileFormKey,
                  child: Column(
                    children: [
                      _displayNameField(),
                      SizedBox(height: 32),
                      _userNameField(),
                      SizedBox(height: 12),
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
          icon: Icon(Icons.close),
          onPressed: () => {Navigator.pop(context)},
          iconSize: 42,
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: Colors.lightBlue,
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
      validator: EmailValidator(errorText: 'Ingrese un e-mail válido'),
    );
  }

// Funciones
//--------------------------------------------------------------------------

  //Realizar la validación de register de usuario
  void _validateFormSend(BuildContext context) {
    setState(() {
      _loading = true;
    });

    //Validar casillas del formulario
    if (_updateProfileFormKey.currentState.validate()) {
      _updateProfileFormKey.currentState.save();

      //Enviar formulario
      _updateResponse = _sendForm();

      //Al recibir respuesta
      _updateResponse.then(
        (updateData) {
          print('Register response');
          print(updateData['validation_data']);

          if (updateData['status'] == 1) {
            print('CAMBIOS GUARDADOS a ' + updateData['status'].toString());
            _updateSharedPreferences();
          } else {
            print('ERROR DE ACTUALIZACIÓN');
            _showValidationErrorDialog(updateData['validation_data']);
          }
        },
      );
    }
  }

  //Enviar datos de formulario y recibir datos de validación
  Future<Map> _sendForm() async {
    var url = Uri.parse(kUrlApi + 'accounts/update/' + _userInfo['userId']);
    var response = await http.post(
      url,
      body: {
        'display_name': _displayNameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar datos de usuario');
    }
  }

  //Actualizar datos de cuenta de usuario en SharedPreferences
  void _updateSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('userDisplayName', _displayNameController.text);
    prefs.setString('userEmail', _emailController.text);
    prefs.setString('username', _usernameController.text);
  }

  //Mostrar diálogo con error de validación
  void _showValidationErrorDialog(validationData) {
    setState(() {
      _loading = false;
    });

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
}
