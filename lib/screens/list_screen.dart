import 'package:bike_kollective/components/app_scaffold.dart';
import 'package:bike_kollective/components/screen_arguments.dart';
import 'package:bike_kollective/screens/bike_details_screen.dart';
import 'package:bike_kollective/app/app_styles.dart';
import 'package:bike_kollective/app/app_strings.dart';
import 'package:bike_kollective/components/size_calculator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'loading_screen.dart';
import '../services/database_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ListScreen extends StatefulWidget {
  static const routeName = 'list';
  final DatabaseManager _db = DatabaseManager();

  ListScreen({Key key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String dropdownSize = 'Choose Size', dropdownType = 'Choose Type';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._db.searchAvailableBikes(dropdownSize, dropdownType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScreen();
        }
        return _bikeListView(snapshot);
      },
    );
  }

  Widget _bikeListView(snapshot) {
    return AppScaffold(
      title: '${AppStrings.bikeListScreenTitle}',
      drawer: null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: sizeCalculator(context, 0.02),
              top: sizeCalculator(context, 0.01),
              right: sizeCalculator(context, 0.02)),
          child: Container(
            child: Column(
              children: <Widget>[
                _sizeFilter(),
                _typeFilter(),
                _bikeList(snapshot),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizeFilter() {
    return DropdownButtonFormField<String>(
        value: dropdownSize,
        onChanged: (String newValue) {
          setState(() {
            dropdownSize = newValue;
          });
        },
        items: <String>['Choose Size', 'Small', 'Medium', 'Large', 'XL']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList());
  }

  Widget _typeFilter() {
    return DropdownButtonFormField<String>(
        value: dropdownType,
        onChanged: (String newValue) {
          setState(() {
            dropdownType = newValue;
          });
        },
        items: <String>['Choose Type', 'Road', 'Commuting', 'BMX']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList());
  }

  Widget _bikeList(snapshot) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: sizeCalculator(context, 0.01)),
        child: ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot bike = snapshot.data.documents[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(bike.data["image"]),
                backgroundColor: Colors.black,
              ),
              title: Text(bike.data["size"] + " " + bike.data["type"]),
              trailing: SmoothStarRating(
                rating: _getRating(bike),
                isReadOnly: true,
                size: 25,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                starCount: 5,
                spacing: 0,
                color: AppStyles.bikeListStarColor,
                borderColor: AppStyles.bikeListStarBorderColor,
              ),
              onTap: () {
                _pushBikeDetails(bike.documentID);
              },
            );
          },
        ),
      ),
    );
  }

  double _getRating(bike) {
    return bike.data.containsKey('${AppStrings.bikeRatingKey}')
        ? bike['${AppStrings.bikeRatingKey}'].toDouble()
        : 0.0;
  }

  void _pushBikeDetails(documentID) {
    Navigator.pushNamed(context, BikeDetailsScreen.routeName,
        arguments: ScreenArguments(documentID: documentID));
  }
}
