import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '../app/app_styles.dart';
import '../components/app_scaffold.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/location_on_app_drawer.dart';
import '../app/app_strings.dart';

class AddBikeScreen extends StatefulWidget {
  static const routeName = 'add';
  final String userEmail;

  AddBikeScreen({Key key, @required this.userEmail}) : super(key: key);

  @override
  _AddBikeScreenState createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  var _scaffoldContext;
  File _image;
  final picker = ImagePicker();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Firestore firestore = Firestore.instance;
  CollectionReference bikes = Firestore.instance.collection('bikes');

  Location location = new Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool _serviceEnabled;

  // JSON categorie variables
  String inputType, inputSize, inputCombo, uploadedFileURL;
  var _documentID;
  double inputLat, inputLng, rating;
  int ratingNum;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '${AppStrings.addBikeScreenTitle}',
      drawer: null,
      body: ModalProgressHUD(
        progressIndicator: SpinKitWave(
          color: Colors.black,
          size: 100.0,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _formBuilder(),
                _addPhoto(),
                _submitButton(),
              ],
            ),
          ),
        ),
        inAsyncCall: _saving,
      ),
    );
  }

  Widget _formBuilder() {
    return FormBuilder(
      key: _fbKey,
      child: Column(
        children: [
          FormBuilderDropdown(
            attribute: "bikeType",
            hint: Text('Select Type of Bike'),
            validators: [FormBuilderValidators.required()],
            items: ['Road', 'Commuting', 'BMX']
                .map((bikeType) =>
                    DropdownMenuItem(value: bikeType, child: Text("$bikeType")))
                .toList(),
            decoration:
                InputDecoration(contentPadding: EdgeInsets.only(top: 40.0)),
          ),
          FormBuilderDropdown(
            attribute: "bikeSize",
            hint: Text('Select Size of Bike'),
            validators: [FormBuilderValidators.required()],
            items: ['Small', 'Medium', 'Large', 'XL']
                .map((bikeSize) =>
                    DropdownMenuItem(value: bikeSize, child: Text("$bikeSize")))
                .toList(),
            decoration:
                InputDecoration(contentPadding: EdgeInsets.only(top: 40.0)),
          ),
          FormBuilderTextField(
              attribute: "bikeCombo",
              autofocus: false,
              decoration: InputDecoration(
                  labelText: "Combo of Bike Lock",
                  contentPadding: EdgeInsets.only(top: 40.0),
                  focusColor: Colors.black),
              validators: [FormBuilderValidators.required()]),
        ],
      ),
    );
  }

  Widget _addPhoto() {
    return Container(
      margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: _image == null
          ? IconButton(
              icon: Icon(Icons.add_a_photo, color: Colors.black, size: 60.0),
              onPressed: _getImage)
          : Stack(
              children: <Widget>[
                Image.file(
                  _image,
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                    )),
              ],
            ),
    );
  }

  void _noPhotoAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Please take a landscape picture of the bike!"),
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

  Widget _submitButton() {
    return Container(
        child: RaisedButton(
            child: Text("upload photo"),
            onPressed: () async {
              if (_fbKey.currentState.saveAndValidate()) {
                if (_image != null) {
                  uploadFile();
                }
                if (_image == null) {
                  _noPhotoAlert();
                }
              }
            }));
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    var image = File(pickedFile.path);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    if (decodedImage.height > decodedImage.width) {
      _noPhotoAlert();
      return;
    }

    if (pickedFile != null)
      setState(() {
        _image = File(pickedFile.path);
      });
  }

  Future<void> _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }

  Future uploadFile() async {
    setState(() {
      _saving = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('bikes/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;

    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        uploadedFileURL = fileURL;
        uploadJson();
      });
    });
  }

  Future uploadJson() async {
    print(_fbKey.currentState.value);
    // store map elements as individual vars to send to firebase
    inputType = _fbKey.currentState.value.values.elementAt(0);
    inputSize = _fbKey.currentState.value.values.elementAt(1);
    inputCombo = _fbKey.currentState.value.values.elementAt(2);

    print("json2");
    // get location and store lat/long in variables
    _getLocation().then((value) {
      inputLat = _locationData.latitude;
      inputLng = _locationData.longitude;

      // Add data to Firestore
      addBike();
    });
  }

  Future<void> addBike() {
// Call the users CollectionReference to add a new user
    return bikes.add({
      'checkedOut': false,
      'type': inputType,
      'size': inputSize,
      'rating': 4,
      'ratingNum': 0,
      'combination': inputCombo,
      'latitude': inputLat,
      'longitude': inputLng,
      'image': uploadedFileURL,
    }).then((value) {
      print("Bike Added");
      _documentID = value.documentID;
      setState(() {
        _saving = false;
      });
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add bike: $error"));
  }
}
