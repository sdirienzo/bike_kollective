import 'dart:io';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddBikeScreen extends StatefulWidget {
  AddBikeScreen({Key key,}) : super(key: key);

  @override
  _AddBikeScreenState createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  File _image;
  final picker = ImagePicker();

  Future getCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  Future getGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog() {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Pick One"),
        content: SingleChildScrollView(
          child: ListBody(
            children:<Widget>[
              GestureDetector(
                child: Text("Camera"),
                onTap: () {
                  getCamera(context);
                },
              ), 
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Gallery"),
                onTap: () {
                  getGallery(context);
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
        title: Text('Add New Bike'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  FormBuilderDropdown(
                    attribute: "bikeType",
                    decoration: InputDecoration(labelText: "Type of Bike"),
                    hint: Text('Select Type of Bike'),
                    validators: [FormBuilderValidators.required()],
                    items: ['Road Bike', 'Commuting Bike', 'Single Speed']
                      .map((bikeType) => DropdownMenuItem(
                        value: bikeType,
                        child: Text("$bikeType")
                    )).toList(),
                  ),
                  FormBuilderTextField(
                    attribute: "bikeSize",
                    decoration: InputDecoration(labelText: "Size of Bike (inches)"),
                    validators: [
                      FormBuilderValidators.minLength(2),
                      FormBuilderValidators.maxLength(4),
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(25),
                      FormBuilderValidators.max(38),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "bikeCombo",
                    decoration: InputDecoration(labelText: "Combo of Bike Lock"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  Container(
                    child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image, width:300,height: 300),
                  ),
                  Container(
                    child: MaterialButton(
                      child: Text("Bike is Secure and Ready to Share"),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),  
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showChoiceDialog,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}