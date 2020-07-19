import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ActiveScreen extends StatefulWidget {
  ActiveScreen({Key key,}) : super(key: key);

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  
  final firestoreInstance = Firestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;

  String bikeImgURL, bikeCombo;

  String uid = "BBNBYHQwq3aWriNlAc9S"; 

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
  
  

  String getImageURL(String docID) {
    firestoreInstance.collection("bikes").document(uid).get().then((value){
      bikeImgURL = value.data["image"];
    });
    return bikeImgURL;
  }

  String getCombo(String docID) {
    firestoreInstance.collection("bikes").document(uid).get().then((value){
      bikeCombo = value.data["combination"];
    });
    return bikeCombo;
  }
  
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Ride'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Active Ride"),
            Image.network(getImageURL(uid)),
            Text(getCombo(uid)),
            RaisedButton(
              child: Text("Check In"),
              onPressed: () {
                getCurrentLocation();
                var inputLat = _currentPosition.latitude;
                var inputLng = _currentPosition.longitude;

                // Add data to Firestore
                firestoreInstance.collection("bikes").document(uid).updateData(
                {
                  "checkedOut" : false,
                  "latitude" : inputLat,
                  "longitude" : inputLng, 
                }).then((_){
                  Navigator.pushNamed(context, '/add');
                });
                

              }             
            )
          ]
        ),
      ),
    );

  }

}

