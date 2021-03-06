import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_settings/app_settings.dart';
import '../components/app_scaffold.dart';
import '../components/location_off_app_drawer.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class LocationRequestScreen extends StatelessWidget {
  final String userEmail;
  final bool locationServiceEnabled;
  final LatLng _center = const LatLng(39.8283, -98.5795);
  GoogleMapController _mapController;

  LocationRequestScreen({Key key, this.userEmail, this.locationServiceEnabled})
      : super(key: key);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.appTitle,
      drawer: LocationOffAppDrawer(userEmail: userEmail),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _turnOnLocationContainer(),
            _map(),
          ],
        ),
      ),
    );
  }

  Widget _turnOnLocationContainer() {
    return Material(
      elevation: 2.0,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0),
          child: Column(
            children: <Widget>[
              _locationOffMessageRow(),
              _locationOffDetailsRow(),
              _turnOnLocationButtonRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationOffMessageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${AppStrings.locationOffMessage}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _locationOffDetailsRow() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${AppStrings.locationOffDetails}'),
        ],
      ),
    );
  }

  Widget _turnOnLocationButtonRow() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _turnOnLocationButton(),
          ),
        ],
      ),
    );
  }

  Widget _turnOnLocationButton() {
    return RaisedButton(
      color: AppStyles.primaryButtonColor,
      textColor: AppStyles.primaryButtonTextColor,
      child: Text('${AppStrings.turnOnLocationButtonLabel}'),
      onPressed: () {
        if (!locationServiceEnabled) {
          AppSettings.openLocationSettings();
        } else {
          AppSettings.openAppSettings();
        }
      },
    );
  }

  Widget _map() {
    return Expanded(
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
        myLocationEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 3.5,
        ),
      ),
    );
  }
}
