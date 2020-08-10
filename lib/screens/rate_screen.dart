import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bike_kollective/screens/home_screen.dart';
import '../components/size_calculator.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';
import '../app/app.dart';
import '../services/database_manager.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateScreen extends StatefulWidget {
  static const routeName = 'rate';

  final String documentID;
  final DatabaseManager _db = DatabaseManager();

  RateScreen({Key key, @required this.documentID}) : super(key: key);

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final firestoreInstance = Firestore.instance;

  double rating, numRating, newRating;

  DocumentSnapshot _bike;
  Image _bikeImage;

  @override
  void initState() {
    _getBikeDetails().then((bikeResult) {
      _bikeImage = Image.network(_bike['${AppStrings.bikeImageKey}']);
      _bikeImage.image
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((info, call) {}));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Your Ride!'),
      ),
      body: Center(
        child: Column(children: [
          Text("How was the Bike?"),
          rateBike(),
          submitButton(),
        ]),
      ),
    );
  }

  Widget rateBike() {
    return Container(
      child: SmoothStarRating(
        rating: newRating,
        isReadOnly: false,
        size: 40,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        defaultIconData: Icons.star_border,
        starCount: 5,
        allowHalfRating: false,
        spacing: 2.0,
        onRated: (value) {
          newRating = value;
        },
      ),
    );
  }

  Widget submitButton() {
    return RaisedButton(
        child: Text("Submit"),
        onPressed: () {
          // calculate new rating
          calcRating();
          // Add data to Firestore
          firestoreInstance
              .collection("bikes")
              .document(widget.documentID)
              .updateData({
            "rating": rating,
          }).then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          });
        });
  }

  void calcRating() {
    // retrieve current rating and number of ratings
    rating = _getRating();
    numRating = _getRatingNum();

    if (numRating == 0) {
      numRating++;
      rating = newRating;
    } else {
      // calculate new rating average
      rating = rating * numRating;
      numRating++;
      // return new average
      rating = (rating + newRating) / numRating;
    }
  }

  double _getRating() {
    return _bike.data.containsKey('${AppStrings.bikeRatingKey}')
        ? _bike['${AppStrings.bikeRatingKey}'].toDouble()
        : 0.0;
  }

  double _getRatingNum() {
    return _bike.data.containsKey('${AppStrings.bikeRatingNumKey}')
        ? _bike['${AppStrings.bikeRatingNumKey}'].toDouble()
        : 0.0;
  }

  Future<void> _getBikeDetails() async {
    _bike = await widget._db.getBike(widget.documentID);
    return;
  }
}
