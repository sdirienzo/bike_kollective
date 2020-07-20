import 'package:bike_kollective/screens/rate_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../components/size_calculator.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';
import '../app/app.dart';


class ActiveScreen extends StatefulWidget {
  static const routeName = '/active';

  final DocumentSnapshot bikeDB;
  final String documentID;

  ActiveScreen({
    Key key, 
    @required this.bikeDB,
    @required this.documentID,   
  }) : super(key: key);
  
  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  
  final firestoreInstance = Firestore.instance;

  bool _isLoaded = false;
  Image _bikeImage;

  int _update = 0;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Location _location = Location();
  LocationData _locationData;

  @override
  void initState() {
    
    _bikeImage = Image.network(widget.bikeDB['${AppStrings.bikeImageKey}']);
    _bikeImage.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((info, call) {
      setState(() {
        _isLoaded = true;
      });
    }));
    
    _location.onLocationChanged.listen((newLoc) {
      _locationData = newLoc;
    });
    _getLocation();

    super.initState();
  }

  Future<void> _getLocation() async {
    var currentLocation = await _location.getLocation();
    setState(() {
      _locationData = currentLocation;
    });
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
            _image(),
            _combo(),
            RaisedButton(
              child: Text("Check In"),
              onPressed: () {
                _getLocation();
                var _inputLat = _locationData.latitude;
                var _inputLng = _locationData.longitude;
                // Add data to Firestore
                firestoreInstance.collection("bikes").document(widget.documentID).updateData(
                {
                  "checkedOut" : false,
                  "latitude" : _inputLat,
                  "longitude" : _inputLng, 
                }).then((_){
                  _update = 1;
                });
                
                if (_update == 1) {
                  print(_update);
                  Navigator.pushNamed(
                    context,
                    RateScreen.routeName,
                    arguments: ScreenArguments(
                      widget.bikeDB,
                      widget.documentID,
                    ),
                  );
                }
                

              }             
            )
          ]
        ),
      ),
    );

  }

  Widget _image() {
    return _bikeImage;
  }

  Widget _combo() {
    return Padding(
      padding: EdgeInsets.only(top: sizeCalculator(context, 0.04)),
      child: Center(
        child: Text(
          widget.bikeDB['${AppStrings.bikeCombinationKey}'],
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

}

