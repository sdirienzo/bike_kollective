import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:bike_kollective/app/app_styles.dart';
import 'package:bike_kollective/app/app_strings.dart';
import 'package:bike_kollective/components/app_scaffold.dart';
import 'package:bike_kollective/components/screen_arguments.dart';
import 'package:bike_kollective/components/size_calculator.dart';
import 'package:bike_kollective/screens/rate_screen.dart';
import 'package:bike_kollective/screens/loading_screen.dart';
import 'package:bike_kollective/screens/location_request_screen.dart';
import 'package:bike_kollective/services/database_manager.dart';

class ActiveScreen extends StatefulWidget {
  static const routeName = 'active';

  final String userID, rideID, documentID;
  final DocumentSnapshot bikeDB;
  final DatabaseManager _db = DatabaseManager();

  ActiveScreen(
      {Key key,
      @required this.userID,
      @required this.bikeDB,
      @required this.documentID,
      @required this.rideID})
      : super(key: key);

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen>
    with WidgetsBindingObserver {
  bool _locationServiceStatus;
  PermissionStatus _locationPermissionStatus;
  Location _location = Location();
  DocumentSnapshot _user;
  Image _bikeImage;

  @override
  void initState() {
    _addObserver();
    _bikeImage = Image.network(widget.bikeDB['${AppStrings.bikeImageKey}']);
    _bikeImage.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((info, call) {
      _getUser(widget.userID).then((user) {
        _setUser(user);
        _checkLocationService().then((serviceStatus) {
          _checkLocationPermission().then((permissionStatus) {
            _updateLocationStatuses(serviceStatus, permissionStatus);
          });
        });
      });
    }));
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
    return _viewToDisplay();
  }

  Widget _viewToDisplay() {
    if (_locationServiceStatus == null) {
      return LoadingScreen();
    } else if (_locationServiceStatus == false ||
        _locationPermissionStatus != PermissionStatus.granted) {
      return LocationRequestScreen(
          userEmail: _user['${AppStrings.userEmailKey}'],
          locationServiceEnabled: _locationServiceStatus);
    } else {
      return _activeRideView();
    }
  }

  Widget _activeRideView() {
    return AppScaffold(
      title: '${AppStrings.activeRideScreenTitle}',
      drawer: null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
              sizeCalculator(context, AppStyles.activeRidePadding)),
          child: Container(
            child: ListView(
              children: <Widget>[
                _image(),
                _combo(),
                _checkInButton(),
              ],
            ),
          ),
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
      child: Column(children: [
        Text(
          'Lock Combination:',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          widget.bikeDB['${AppStrings.bikeCombinationKey}'],
          style: TextStyle(fontSize: 40),
        ),
      ]),
    );
  }

  Widget _checkInButton() {
    return Padding(
      padding: EdgeInsets.only(top: sizeCalculator(context, 0.04)),
      child: SizedBox(
        child: RaisedButton(
          color: AppStyles.primaryButtonColor,
          textColor: AppStyles.primaryButtonTextColor,
          child: Text('${AppStrings.checkinButtonLabel}'),
          onPressed: () {
            _submitCheckIn();
          },
        ),
      ),
    );
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

  Future<DocumentSnapshot> _getUser(userId) async {
    return await widget._db.getUser(userId);
  }

  Future<bool> _checkLocationService() async {
    return await _location.serviceEnabled();
  }

  Future<PermissionStatus> _checkLocationPermission() async {
    return await _location.hasPermission();
  }

  Future<LocationData> _getLocation() async {
    return await _location.getLocation();
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

  void _submitCheckIn() {
    _getLocation().then((location) {
      _endRide(widget.documentID, widget.userID, widget.rideID,
              location.latitude, location.longitude)
          .then((result) {
        _pushRateScreen();
      });
    });
  }

  Future<void> _endRide(String bikeId, String userId, String rideId,
      double latitude, double longitude) {
    var endTime = DateTime.now();
    return widget._db
        .checkInBike(bikeId, latitude, longitude)
        .then((checkInResult) {
      return widget._db.endActiveRide(rideId, endTime).then((endRideResult) {
        return widget._db
            .removeUserActiveRide(userId)
            .then((removeUserRideResult) {
          return;
        });
      });
    });
  }

  void _pushRateScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RateScreen.routeName,
      (route) => false,
      arguments: ScreenArguments(
        documentID: widget.documentID,
      ),
    );
  }
}
