import 'package:bike_kollective/components/screen_arguments.dart';
import 'package:bike_kollective/screens/bike_details_screen.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Bike List'),
        ),
        body: Container(
            child: Column(
          children: [
            DropdownButtonFormField<String>(
                value: dropdownSize,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownSize = newValue;
                  });
                },
                items: <String>['Choose Size', 'Small', 'Medium', 'Large', 'XL']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()),
            DropdownButtonFormField<String>(
                value: dropdownType,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownType = newValue;
                  });
                },
                items: <String>['Choose Type', 'Road', 'Commuting', 'BMX']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()),
            StreamBuilder(
              stream:
                  widget._db.searchAvailableBikes(dropdownSize, dropdownType),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot bike =
                                snapshot.data.documents[index];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(bike.data["image"]),
                              ),
                              title: Text(
                                  bike.data["size"] + " " + bike.data["type"]),
                              trailing: SmoothStarRating(
                                rating: bike.data["rating"].toDouble(),
                                isReadOnly: true,
                                size: 25,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                spacing: 0,
                              ),
                              onTap: () {
                                _pushBikeDetails(bike.documentID);
                              },
                            );
                          }));
                } else {
                  return LoadingScreen();
                }
              },
            ),
          ],
        )));
  }

  void _pushBikeDetails(documentID) {
    Navigator.pushNamed(context, BikeDetailsScreen.routeName,
        arguments: ScreenArguments(documentID: documentID));
  }
}
