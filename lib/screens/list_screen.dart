import 'package:bike_kollective/components/screen_arguments.dart';
import 'package:bike_kollective/screens/bike_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'loading_screen.dart';
import '../services/database_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class ListScreen extends StatefulWidget {
  static const routeName = 'list';
  final DatabaseManager _db = DatabaseManager();


  ListScreen({Key key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bike List'),
        ),
        body: Container(
            child: StreamBuilder(
              stream: widget._db.getAllAvailableBikes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   return ListView.builder(
                      itemCount:  snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot bike = snapshot.data.documents[index];
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                bike.data["image"]),
                          ),
                          title: Text(bike.data["size"] +
                              " " +
                              bike.data["type"]),
                          onTap: () {
                            _pushBikeDetails(bike.documentID); 
                          },
                        );
                      }
                    );
                } else {
                  return LoadingScreen();
                }
              },
            ),   
        )
    );
  }
  
  void _pushBikeDetails(documentID) {
    Navigator.pushNamed(context, BikeDetailsScreen.routeName,
        arguments: ScreenArguments(documentID: documentID));
  }

}
