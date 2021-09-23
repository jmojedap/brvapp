import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Accounts/models/account_model.dart';

class UserPictureScreen extends StatefulWidget {
  //UserPictureScreen({Key? key}) : super(key: key);

  @override
  _UserPictureScreenState createState() => _UserPictureScreenState();
}

class _UserPictureScreenState extends State<UserPictureScreen> {
  final _userId = UserSimplePreferences.getUserId();
  final _userKey = UserSimplePreferences.getUserKey();
  final _userPicture = UserSimplePreferences.getUserPicture();
  File _imageFile;
  final picker = ImagePicker();
  Future<Map> _futureUploadPicture;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Foto de perfil')),
      body: bodyContent(),
    );
  }

  //Seleccionar imagen de archivo o cámara, con ImagePicker
  //Y recortarla con ImageCropper
  Future _pickImage(ImageSource source) async {
    setState(() => _loading = true);
    XFile pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 720,
        maxHeight: 720,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: kBgColors['appPrimary'],
          toolbarTitle: 'Recortar',
          statusBarColor: kBgColors['appDark'],
          backgroundColor: Colors.white,
        ),
      );

      _imageFile = cropped;
      setState(() => _loading = false);
    }
  }

  //Contenido de body, Scaffold
  Widget bodyContent() {
    if (_loading) {
      return _loadingWidget();
    } else {
      if (_imageFile != null) {
        return contentImage();
      } else {
        return contentNoImage();
      }
    }
  }

  //Body content cuando hay imagen seleccionada
  Widget contentImage() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buttonsTop(),
          CircleAvatar(
            radius: 120,
            backgroundImage: FileImage(_imageFile),
          ),
        ],
      ),
    );
  }

  //Botones para parte superior cuando ya hay imagen elegida y recortada
  //Aceptar o cancelar.
  Widget _buttonsTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            _imageFile = null;
            setState(() {});
          },
          iconSize: 42,
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: kBgColors['appDark'],
          ),
          onPressed: () {
            print('Enviando botón');
            uploadPicture();
          },
          iconSize: 42,
        ),
      ],
    );
  }

  //Body content cuando no hay imagen seleccionada
  Widget contentNoImage() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(children: [
          CircleAvatar(
            radius: 120,
            backgroundImage: NetworkImage(_userPicture),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 6),
                    Text('Cámara'),
                  ],
                ),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Row(
                  children: [
                    Icon(Icons.folder_outlined),
                    SizedBox(width: 6),
                    Text('Galería'),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  //Contenido de cargue mientras se selecciona y recorta la foto
  Widget _loadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  //Ejecuta el cargue de la imagen al servidor
  void uploadPicture() {
    setState(() => _loading = true);
    _futureUploadPicture =
        AccountModel().setPicture(_userId, _userKey, _imageFile.path);

    _futureUploadPicture.then(
      (mapResponse) {
        setState(() => _loading = false);

        if (mapResponse['status'] == 1) {
          print('URL nueva imagen:');
          print(mapResponse['url_image']);
          UserSimplePreferences.setUserPicture(mapResponse['url_image']);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/profile', (route) => false);
        }
      },
    );
  }
}
