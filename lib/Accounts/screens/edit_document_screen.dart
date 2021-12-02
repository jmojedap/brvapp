import 'package:flutter/material.dart';
import 'dart:async';
import 'package:brave_app/Accounts/models/account_model.dart';
import 'package:brave_app/User/models/user_tools.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

class EditDocumentScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);

  @override
  _EditDocumentScreenState createState() => _EditDocumentScreenState();
}

class _EditDocumentScreenState extends State<EditDocumentScreen> {
// Variables
//--------------------------------------------------------------------------

  String userId = UserSimplePreferences.getUserId();
  String userKey = UserSimplePreferences.getUserKey();
  Future<Map> futureUserInfo;
  Map userInfo = {'document_number': '', 'document_type': '1'};

  Future<Map> _updateResponse;
  bool loading = true;

  TextEditingController _documentNumberController;

  final _updateProfileFormKey = GlobalKey<FormState>();
  final _scaffKey = GlobalKey<ScaffoldState>();

// Obtener datos de usuario por SharedPreferences
//--------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  /* Cargar datos de usuario de SharedPreferences */
  void getUserInfo() async {
    futureUserInfo = UserTools().getInfo(userId, 'general');

    futureUserInfo.then((mapResponse) {
      loading = false;
      userInfo = mapResponse['user'];
      setState(() {
        _documentNumberController =
            TextEditingController(text: userInfo['document_number']);
      });
    });
  }

// Constructor
//--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffKey,
        body: bodyContent(),
      ),
    );
  }

  Widget bodyContent() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
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
                    _documentNumberField(),
                    SizedBox(height: 24),
                    _documentTypes(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
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

  Widget _documentNumberField() {
    return TextFormField(
      controller: _documentNumberController,
      decoration: InputDecoration(
        labelText: 'Número documento',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor complete esta casilla';
        }
        return null;
      },
    );
  }

  Widget _documentTypes() {
    return DropdownButtonFormField(
      value: userInfo['document_type'],
      decoration: InputDecoration(
        labelText: 'Tipo',
      ),
      items: [
        DropdownMenuItem(
          child: Text('Cédula de ciudadanía'),
          value: '1',
        ),
        DropdownMenuItem(
          child: Text('Cédula extranjería'),
          value: '3',
        ),
        DropdownMenuItem(
          child: Text('Pasaporte'),
          value: '4',
        ),
        DropdownMenuItem(
          child: Text('Tarjeta de identidad'),
          value: '5',
        ),
      ],
      onChanged: (value) {
        userInfo['document_type'] = value;
        print('document_type: ' + userInfo['document_type']);
      },
    );
  }

// Funciones
//--------------------------------------------------------------------------

  //Realizar la validación de register de usuario
  void _validateFormSend(BuildContext context) {
    setState(() => loading = true);

    //Validar casillas del formulario
    if (_updateProfileFormKey.currentState.validate()) {
      _updateProfileFormKey.currentState.save();

      //Enviar formulario
      _updateResponse = AccountModel().updateProfile(
        userId,
        {
          'document_number': _documentNumberController.text,
          'document_type': userInfo['document_type'],
        },
      );

      //Al recibir respuesta
      _updateResponse.then(
        (updateData) {
          setState(() => loading = false);

          if (updateData['status'] == 1) {
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
