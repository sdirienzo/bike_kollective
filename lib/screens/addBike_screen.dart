import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddBikeScreen extends StatefulWidget {
  AddBikeScreen({Key key,}) : super(key: key);

  @override
  _AddBikeScreenState createState() => _AddBikeScreenState();
}


class _AddBikeScreenState extends State<AddBikeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  File imageFile;
  final picker = ImagePicker();

  _openGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      this.imageFile = File(pickedFile.path);
    }); 
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      this.imageFile = File(pickedFile.path);
    });
    Navigator.of(context).pop(); 
  }
  
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Pick One"),
        content: SingleChildScrollView(
          child: ListBody(
            children:<Widget>[
              GestureDetector(
                child: Text("Camera"),
                onTap: () {
                  _openCamera(context);
                },
              ), 
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Gallery"),
                onTap: () {
                  _openGallery(context);
                },
              )
            ],
          ), 
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Bike')
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:<Widget>[
            Text('No Image Selected'),
            RaisedButton(onPressed: (){
              _showChoiceDialog(context);
            }, child: Text('Select Image'),)
          ],
        ),
      ),
    );
  }
  
}
