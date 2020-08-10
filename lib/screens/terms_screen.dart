import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '../app/app_styles.dart';

class AddBikeScreen extends StatefulWidget {
  static const routeName = 'add';

  AddBikeScreen({
    Key key,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryScaffoldBackgroundColor,
      body: Builder(builder: (BuildContext context) {
        _scaffoldContext = context;
        return SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              _terms(),
              _formBuilder(),
              _submitButton(),
            ],
          ),
        ));
      }),
    );
  }

  Widget _terms() {
    return Column();
  }

  Widget _formBuilder() {}

  Widget _submitButton() {}
}
