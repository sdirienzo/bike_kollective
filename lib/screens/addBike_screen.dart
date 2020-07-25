import 'dart:io';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart';

class AddBikeScreen extends StatefulWidget {
  static const routeName = 'add';

  AddBikeScreen({Key key}) : super(key: key);

  @override
  _AddBikeScreenState createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final firestoreInstance = Firestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;

  File _image;
  final picker = ImagePicker();
  String _uploadedFileURL;

  // got this function at https://stackoverflow.com/a/60735956/13923874
  Future<File> fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final height = originalImage.height;
    final width = originalImage.width;

    //final GoogleSignIn _googleSignIn = GoogleSignIn();
    //final FirebaseAuth _auth = FirebaseAuth.instance;

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

  //function to upload file. From https://www.c-sharpcorner.com/article/upload-image-file-to-firebase-storage-using-flutter/
  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('bikes/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  // function to take and get picture from camera
  Future getCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      fixExifRotation(pickedFile.path);
      _image = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  // function to get a picture from gallery
  Future getGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      fixExifRotation(pickedFile.path);
      _image = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  // pop-up to pic between camera and gallery, then call each of those functions
  Future<void> _showChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick One"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
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

  // alert pop-up asking for a bike picture
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

  // main widget tree
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
                    items: ['Road', 'Commuting', 'BMX']
                        .map((bikeType) => DropdownMenuItem(
                            value: bikeType, child: Text("$bikeType")))
                        .toList(),
                  ),
                  FormBuilderDropdown(
                    attribute: "bikeSize",
                    hint: Text('Select Size of Bike'),
                    validators: [FormBuilderValidators.required()],
                    items: ['Small', 'Medium', 'Large']
                        .map((bikeSize) => DropdownMenuItem(
                            value: bikeSize, child: Text("$bikeSize")))
                        .toList(),
                  ),
                  FormBuilderTextField(
                    attribute: "bikeCombo",
                    decoration:
                        InputDecoration(labelText: "Combo of Bike Lock"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                    child: _image == null
                        ? IconButton(
                            icon: Icon(Icons.add_a_photo,
                                color: Colors.blue, size: 60.0),
                            onPressed: _showChoiceDialog,
                          )
                        //: Image.file(_image,),
                        : Stack(
                            children: <Widget>[
                              Image.file(
                                _image,
                              ),
                              Positioned(
                                  top: 5,
                                  right:
                                      5, //give the values according to your requirement
                                  child: IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                  )),
                            ],
                          ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text("Bike is Secure and Ready to Share"),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          if (_image != null) {
                            // upload file to firebase storage
                            uploadFile();

                            // store map elements as individual vars to send to firebase
                            var inputType =
                                _fbKey.currentState.value.values.elementAt(0);
                            var inputSize =
                                _fbKey.currentState.value.values.elementAt(1);
                            var inputCombo =
                                _fbKey.currentState.value.values.elementAt(2);
                            // get location and store lat/long in variables
                            getCurrentLocation();
                            var inputLat = _currentPosition.latitude;
                            var inputLng = _currentPosition.longitude;

                            var _documentID;

                            // Add data to Firestore
                            firestoreInstance.collection("bikes").add({
                              "checkedOut": false,
                              "type": inputType,
                              "size": inputSize,
                              "combination": inputCombo,
                              "latitude": inputLat,
                              "longitude": inputLng,
                              "image": _uploadedFileURL,
                            }).then((value) {
                              _documentID = value.documentID;
                            });

                            if (_documentID != 0) {
                              Navigator.pop(context);
                            }
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
