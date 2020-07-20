import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bike_kollective/screens/home_screen.dart';
import '../services/database_manager.dart';
import '../components/size_calculator.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';
import '../app/app.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class RateScreen extends StatefulWidget {
  static const routeName = '/rate';

  final String documentID;

  RateScreen({
    Key key, 
    @required this.documentID,   
  }) : super(key: key);
  
  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  
  final firestoreInstance = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    double rating = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Your Ride!'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("How was the Bike?"),
            SmoothStarRating(
              rating: rating,
              isReadOnly: false,
              size: 40,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: false,
              spacing: 2.0,
              onRated: (value) {
                rating = value;
              },
            ),
            RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                // Add data to Firestore
                firestoreInstance.collection("bikes").document(widget.documentID).updateData(
                {
                  "rating" : rating,   
                }).then((_){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),        
                    ),
                  );
                });
                

              }             
            )
          ]
        ),
      ),
    );

  }

}

