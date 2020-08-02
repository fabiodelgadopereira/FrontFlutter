import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class UploadPage extends StatelessWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;
  int _counter = 0;
  File _image;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  Future getImage() async {
    try {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadFile(image);
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  // Methode for file upload
  void _uploadFile(filePath) async {
    try {
      // Get base file name
      String fileName = basename(filePath.path);
      print("File base name: $fileName");

      FormData formData = new FormData.fromMap(
          {"file": await MultipartFile.fromFile(filePath, filename: fileName)});

      Response response = await Dio()
          .post("http://localhost:5003/api/FileUpload", data: formData);
      print("File upload response: $response");

      // Show the incoming message in snakbar
      _showSnakBarMsg(response.data['message']);
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  // Method for showing snak bar message
  void _showSnakBarMsg(String msg) {
    _scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldstate,
      body: Center(
        child: _image == null ? Text('Nenhuma imagem selecionada.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
