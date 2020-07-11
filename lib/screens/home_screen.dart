import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'location_request_screen.dart';
import '../services/authentication_manager.dart';
import '../services/database_manager.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.userEmail}) : super(key: key);

  final userEmail;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // GoogleMapController _mapController;
  // var _locationServiceEnabled;
  // PermissionStatus _locationPermissionGranted;
  // LocationData _locationData;
  // Location _location = Location();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocationRequestScreen(userEmail: widget.userEmail);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // print('test');
  //   // DatabaseManager().getAllAvailableBikes().forEach((element) {
  //   //   print(element.documents.length);
  //   // });
  //   // checkLocationService().then((value) {
  //   //   if (_locationServiceEnabled) {
  //   //     checkLocationPermission().then((value) async {
  //   //       if (_locationPermissionGranted == PermissionStatus.granted) {
  //   //         _locationData = await _location.getLocation();
  //   //         print(_locationData.latitude);
  //   //         print(_locationData.longitude);
  //   //       }
  //   //     });
  //   //   }
  //   // });
  // }

  // Future<void> _currentLocation() async {
  //   _locationData = await _location.getLocation();
  // }

  // Future<void> checkLocationService() async {
  //   _locationServiceEnabled = await _location.serviceEnabled();
  //   if (!_locationServiceEnabled) {
  //     _locationServiceEnabled = await _location.requestService();
  //     if (!_locationServiceEnabled) {
  //       return;
  //     }
  //   }
  // }

  // Future<void> checkLocationPermission() async {
  //   _locationPermissionGranted = await _location.hasPermission();
  //   if (_locationPermissionGranted == PermissionStatus.denied) {
  //     _locationPermissionGranted = await _location.requestPermission();
  //     if (_locationPermissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  // }

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  // }

  // void _retrieveLocation() async {
  //   _location = Location();
  //   _location.
  //   var locationData = await locationService.getLocation();
  //   foodWastePost.latitude = locationData.latitude;
  //   foodWastePost.longitude = locationData.longitude;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         "BIKE KOLLECTIVE",
  //         style: TextStyle(
  //           color: Colors.black,
  //         ),
  //       ),
  //       centerTitle: true,
  //       backgroundColor: Colors.white,
  //       iconTheme: IconThemeData(color: Colors.black),
  //     ),
  //     body: GoogleMap(
  //       onMapCreated: _onMapCreated,
  //       mapType: MapType.normal,
  //       myLocationEnabled: true,
  //       initialCameraPosition: CameraPosition(
  //         target: _center,
  //         zoom: 11.0,
  //       ),
  //     ),
  //   );
  // }

}
