import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.userEmail}) : super(key: key);
  final String userEmail;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _location = Location();
  GoogleMapController _mapController;
  LocationData _currentLocation;
  LatLng _center;

  @override
  void initState() {
    _location.onLocationChanged.listen((newLoc) {
      _currentLocation = newLoc;
      _updateLocationIndicator();
    });
    _getInitialLocation();
    super.initState();
  }

  Future<void> _getInitialLocation() async {
    var currentLocation = await _location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      _center = LatLng(_currentLocation.latitude, _currentLocation.longitude);
    });
  }

  void _updateLocationIndicator() async {
    _mapController.getZoomLevel().then((level) {
      CameraPosition position = CameraPosition(
        zoom: level,
        tilt: 0.0,
        bearing: 0.0,
        target: LatLng(
          _currentLocation.latitude,
          _currentLocation.longitude,
        ),
      );
      _mapController.animateCamera(CameraUpdate.newCameraPosition(position));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${AppStrings.appTitle}',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18.0,
          ),
        ),
      );
    }
  }
}
