import 'dart:io';
import 'package:flutter/material.dart';
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
  File _imageFile;
  final picker = ImagePicker();
  final _userId = UserSimplePreferences.getUserId();
  final _userKey = UserSimplePreferences.getUserKey();
  Future<Map> _futureUploadPicture;

  Future _pickImage(ImageSource source) async {
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
          toolbarColor: kBgColors['appLight'],
          toolbarTitle: 'Recortar',
          statusBarColor: kBgColors['appDark'],
          backgroundColor: Colors.white,
        ),
      );

      _imageFile = cropped;
      //_imageFile = pickedImage;
      setState(() {
        print('imagen cortada');
        //_imageFile = cropped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Foto de perfil')),
      body: bodyContent(),
    );
  }

  Widget bodyContent() {
    if (_imageFile != null) {
      return Column(
        children: [
          Image.file(_imageFile),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Enviando botón');
              uploadPicture();
            },
            child: Text('Guardar'),
          ),
        ],
      );
    } else {
      return contentNoImage();
    }
  }

  Widget contentImage() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: FileImage(_imageFile)),
          ),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            print('Enviando botón');
            uploadPicture();
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }

  Widget contentNoImage() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(children: [
          Text(_userKey + '--' + _userId),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
                child: Icon(Icons.camera_alt),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Icon(Icons.folder_outlined, color: Colors.white),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void uploadPicture() {
    _futureUploadPicture =
        AccountModel().setPicture(_userId, _userKey, _imageFile.path);

    _futureUploadPicture.then((stringResponse) {
      print('desde Screen:');
      print(stringResponse);
    });
  }
}
