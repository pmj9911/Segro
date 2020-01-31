import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'camera_save_image.dart';
// import 'package:camera/camera.dart';

class ClassifyImage extends StatefulWidget {
  final Function onSelectImage;

  ClassifyImage(this.onSelectImage);

  @override
  _ClassifyImageState createState() => _ClassifyImageState();
}

class _ClassifyImageState extends State<ClassifyImage> {
  File _storedImage;
  void _upload() {
    if (_storedImage == null) return;
    String base64Image = base64Encode(_storedImage.readAsBytesSync());
    String fileName = _storedImage.path.split("/").last;
    print("inside upload");
    // isSubmitted = true;

    http.post('https://00ecd78c.ngrok.io/prediction', body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
      setState(() {
        isSubmitted = true;
      });
    }).catchError((err) {
      print(err);
    });
  }
  // this function may not work since problems were faced in django rest api accepting the image as a part of the api payload .

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
    // sendImage();
  }

  Future<void> _selectPicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
    // sendImage();
  }

  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isSubmitted
            ? Center(
                child: Text("Your image has been uploaded successfully!"),
              )
            : Center(),
        Container(
          width: double.infinity,
          height: 450,
          margin: EdgeInsets.all(10),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.camera),
                    label: Text('Take Picture'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _takePicture,
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.photo_album),
                    label: Text('select image'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _selectPicture,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: _upload,
                    icon: Icon(Icons.file_upload),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
