import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'location_request_screen.dart';
import 'loading_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.userEmail}) : super(key: key);

  final userEmail;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _locationServiceStatus;
  PermissionStatus _locationPermissionStatus;
  Location _location = Location();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _checkLocationService().then((serviceStatus) async {
      _checkLocationPermission().then((permissionStatus) {
        _updateLocationStatuses(serviceStatus, permissionStatus);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationService().then((serviceStatus) async {
        _checkLocationPermission().then((permissionStatus) {
          _updateLocationStatuses(serviceStatus, permissionStatus);
        });
      });
    }
  }

  void _updateLocationStatuses(
      bool locationServiceStatus, PermissionStatus locationPermissionStatus) {
    if (_locationServiceStatus != locationServiceStatus ||
        _locationPermissionStatus != locationPermissionStatus) {
      setState(() {
        _locationServiceStatus = locationServiceStatus;
        _locationPermissionStatus = locationPermissionStatus;
      });
    }
  }

  Future<bool> _checkLocationService() async {
    return await _location.serviceEnabled();
  }

  Future<PermissionStatus> _checkLocationPermission() async {
    return await _location.hasPermission();
  }

  @override
  Widget build(BuildContext context) {
    return _screenToDisplay();
  }

  Widget _screenToDisplay() {
    if (_locationServiceStatus == null) {
      return LoadingScreen();
    } else if (_locationServiceStatus &&
        _locationPermissionStatus == PermissionStatus.granted) {
      return MapScreen(userEmail: widget.userEmail);
    } else {
      return LocationRequestScreen(
          userEmail: widget.userEmail,
          locationServiceEnabled: _locationServiceStatus);
    }
  }
}
