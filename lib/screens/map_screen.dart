import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'loading_screen.dart';
import '../services/database_manager.dart';
import '../components/app_scaffold.dart';
import '../components/location_on_app_drawer.dart';
import '../app/app_strings.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.userEmail}) : super(key: key);
  final String userEmail;
  final DatabaseManager _db = DatabaseManager();

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _location = Location();
  GoogleMapController _mapController;
  LocationData _currentLocation;
  LatLng _center;
  Set<Marker> _markers = Set<Marker>();

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
    // print(_mapController == null);
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

  void _prepareMarkers(snapshot) {
    _markers.clear();

    snapshot.data.documents.forEach((bike) {
      var markerId = MarkerId(bike.documentID);
      _markers.add(
        Marker(
            markerId: markerId,
            position: LatLng(bike['${AppStrings.bikeLatitudeKey}'],
                bike['${AppStrings.bikeLongitudeKey}']),
            onTap: () {
              _pushBikeDetails(bike.documentID);
            }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _viewToDisplay();
  }

  Widget _viewToDisplay() {
    if (_currentLocation == null) {
      return LoadingScreen();
    } else {
      return _mapView();
    }
  }

  Widget _mapView() {
    return AppScaffold(
      title: AppStrings.appTitle,
      drawer: LocationOnAppDrawer(userEmail: widget.userEmail),
      body: StreamBuilder(
        stream: widget._db.getAllAvailableBikes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _map(snapshot);
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }

  Widget _map(snapshot) {
    _prepareMarkers(snapshot);

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18.0,
      ),
      markers: _markers,
    );
  }

  void _pushBikeDetails(documentID) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => BikeDetailsScreen()));
  }
}
