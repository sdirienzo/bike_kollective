import 'dart:io';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;


class AddBikeScreen extends StatefulWidget {
  AddBikeScreen({Key key,}) : super(key: key);

  @override
  _AddBikeScreenState createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  File _image;
  final picker = ImagePicker();

  // got this function at https://stackoverflow.com/a/60735956/13923874
  Future<File> fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final height = originalImage.height;
    final width = originalImage.width;

    // Let's check for the image size
    // This will be true also for upside-down photos but it's ok for me
    if (height < width) {
      // I'm interested in landscape photos so
      // I'll just return here
      return originalFile;
    }

    // We'll use the exif package to read exif data
    // This is map of several exif properties
    // Let's check 'Image Orientation'
    final exifData = await readExifFromBytes(imageBytes);

    img.Image fixedImage;

    if (height >= width) {
      // rotate
      if (exifData['Image Orientation'].printable.contains('Horizontal')) {
        fixedImage = img.copyRotate(originalImage, 90);
      } else if (exifData['Image Orientation'].printable.contains('180')) {
        fixedImage = img.copyRotate(originalImage, -90);
      } else if (exifData['Image Orientation'].printable.contains('CCW')) {
        fixedImage = img.copyRotate(originalImage, 180);
      } else {
        fixedImage = img.copyRotate(originalImage, 0);
      }
    }

    // Here you can select whether you'd like to save it as png
    // or jpg with some compression
    // I choose jpg with 100% quality
    final fixedFile =
        await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;
  }

  Future getCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      fixExifRotation(pickedFile.path);
      _image = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  Future getGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      fixExifRotation(pickedFile.path);
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

  // altert pop-up asking for a bike picture
  void _showPictureDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Please take a picture of the bike!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    margin: const EdgeInsets.only(top:30.0, bottom:30.0),
                    child: _image == null
                  ? IconButton(
                      icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.blue,
                              size: 60.0
                            ),
                      onPressed: _showChoiceDialog,
                      
                    )  
                  : Image.file(_image,),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text("Bike is Secure and Ready to Share"),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          if (_image != null) {
                            print(_fbKey.currentState.value);
                          }
                          if (_image == null) {
                            _showPictureDialog();
                          }
                          
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
    );
  }
}