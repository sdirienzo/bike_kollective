import 'package:flutter/material.dart';
import 'package:bike_kollective/screens/active_screen.dart';
import 'package:bike_kollective/services/authentication_manager.dart';
import 'package:bike_kollective/services/database_manager.dart';
import 'package:bike_kollective/app/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'location_request_screen.dart';
import 'loading_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  final AuthenticationManager _auth = AuthenticationManager();
  final DatabaseManager _db = DatabaseManager();

  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _locationServiceStatus;
  PermissionStatus _locationPermissionStatus;
  Location _location = Location();
  String _userId, _rideId, _bikeId;
  DocumentSnapshot _user;
  DocumentSnapshot _bike;

  @override
  void initState() {
    _addObserver();
    _getUserId().then((userId) {
      _setUserId(userId);
      _getUser(userId).then((user) {
        _setUser(user);
        _checkLocationService().then((serviceStatus) {
          _checkLocationPermission().then((permissionStatus) {
            if (_userHasActiveRide(user)) {
              _getActiveRideDetails(user).then((rideDetailsResult) {
                _updateLocationStatuses(serviceStatus, permissionStatus);
              });
            } else {
              _updateLocationStatuses(serviceStatus, permissionStatus);
            }
          });
        });
      });
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationService().then((serviceStatus) {
        _checkLocationPermission().then((permissionStatus) {
          _updateLocationStatuses(serviceStatus, permissionStatus);
        });
      });
    }
  }

  @override
  void dispose() {
    _removeObserver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _screenToDisplay();
  }

  Widget _screenToDisplay() {
    if (_locationServiceStatus == null) {
      return LoadingScreen();
    } else if (_locationServiceStatus == false ||
        _locationPermissionStatus != PermissionStatus.granted) {
      return LocationRequestScreen(
          userEmail: _user['${AppStrings.userEmailKey}'],
          locationServiceEnabled: _locationServiceStatus);
    } else if (_locationServiceStatus == true &&
        _locationPermissionStatus == PermissionStatus.granted &&
        _rideId != null) {
      _removeObserver();
      return ActiveScreen(
          userID: _userId, documentID: _bikeId, bikeDB: _bike, rideID: _rideId);
    } else {
      return MapScreen(userEmail: _user['${AppStrings.userEmailKey}']);
    }
  }

  void _setUserId(userId) {
    _userId = userId;
  }

  void _setUser(user) {
    _user = user;
  }

  void _addObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _removeObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  bool _userHasActiveRide(user) {
    return user['${AppStrings.userActiveRideKey}'] != null;
  }

  Future<String> _getUserId() async {
    return await widget._auth.getCurrentUserId();
  }

  Future<DocumentSnapshot> _getUser(userId) async {
    return await widget._db.getUser(userId);
  }

  Future<DocumentSnapshot> _getActiveRide(rideId) async {
    return await widget._db.getActiveRide(rideId);
  }

  Future<DocumentSnapshot> _getBikeDetails(bikeId) async {
    return await widget._db.getBike(bikeId);
  }

  Future<bool> _checkLocationService() async {
    return await _location.serviceEnabled();
  }

  Future<PermissionStatus> _checkLocationPermission() async {
    return await _location.hasPermission();
  }

  Future<void> _getActiveRideDetails(user) async {
    return _getActiveRide(user['${AppStrings.userActiveRideKey}']).then((ride) {
      _rideId = ride.documentID;
      _bikeId = ride['${AppStrings.rideBikeIdKey}'];
      return _getBikeDetails(ride['${AppStrings.rideBikeIdKey}']).then((bike) {
        _bike = bike;
        return;
      });
    });
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
}
