import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  //const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _scaffKey = GlobalKey<ScaffoldState>();

  final TextEditingController _displayNameController =
      TextEditingController(text: 'Lina López');

  final TextEditingController _userNameController =
      TextEditingController(text: 'lina_lopez');

  final TextEditingController _emailController =
      TextEditingController(text: 'linalop@pacarina.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context2) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              Row(
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
                      _confirmSaved(context2);
                    },
                    iconSize: 42,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/img/lina.jpg'),
                radius: 50,
              ),
              SizedBox(height: 6),
              Text(
                'Cambiar foto de perfil',
                style: TextStyle(fontSize: 18, color: Colors.blue[400]),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: _displayNameField(),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: _userNameField(),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: _emailField(),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _confirmSaved(BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text('Datos guardados'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop();
  }

  Widget _displayNameField() {
    return TextFormField(
      controller: _displayNameController,
      decoration: InputDecoration(
        labelText: 'Nombre',
      ),
    );
  }

  Widget _userNameField() {
    return TextFormField(
      controller: _userNameController,
      decoration: InputDecoration(
        labelText: 'Nombre de usuario',
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
      ),
    );
  }
}
