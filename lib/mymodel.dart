import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class myModel extends StatefulWidget {
  @override
  State<myModel> createState() => _myModelState();
}

class _myModelState extends State<myModel> {
  File _image;
  bool _loading = false;
  List<dynamic> _outputs;

  void initState() {
    super.initState();
    _loading = true;

    loadModel2().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

//Load the Tflite model
  loadModel2() async {
    try {
      await Tflite.loadModel(
        model: "assets/nsfw.tflite",
        labels: "assets/label.txt",
      );
    } catch (e) {
      _outputs = e;
    }
  }

  classifyImage2(image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.7,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        _loading = false;
        //Declare List _outputs in the class which will be used to show the classified classs name and confidence
        _outputs = output;
      });
    } catch (e) {
      _outputs = e;
    }
  }

  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    // classifyImage2(image);
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
  }

  // final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == '' || _image == null
                ? Text('No image selected.')
                : Image.file(_image,
                    width: 300, height: 200, fit: BoxFit.cover),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ElevatedButton.icon(
                  label: Text('From Camera'),
                  icon: Icon(Icons.photo_camera),
                  onPressed: () => getImageFromCamera(),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.shade400),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18))),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ElevatedButton.icon(
                  label: Text('From Gallery'),
                  icon: Icon(Icons.photo_camera_back_rounded),
                  onPressed: () => pickImage(),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.brown.shade600),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18))),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ElevatedButton(
                  onPressed: () {
                    classifyImage2(_image);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(20, 10, 20, 10)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18))),
                  child: Text('Check Image type'),
                )),
            _outputs == null
                ? Text('no image to check')
                : Text(_outputs.toString())
          ],
        ),
      ),
    );
  }
}
