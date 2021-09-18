import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brave_app/Config/constants.dart';

class UserPictureScreen extends StatefulWidget {
  //UserPictureScreen({Key? key}) : super(key: key);

  @override
  _UserPictureScreenState createState() => _UserPictureScreenState();
}

class _UserPictureScreenState extends State<UserPictureScreen> {
  File _imageFile;
  final picker = ImagePicker();

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

      setState(() {
        _imageFile = cropped;
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
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(_imageFile)),
        ),
      );
    } else {
      return contentNoImage();
    }
  }

  Widget contentNoImage() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(children: [
          Container(
            width: 200,
            height: 200,
            color: Colors.black38,
            margin: EdgeInsets.only(bottom: 12),
          ),
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
}
