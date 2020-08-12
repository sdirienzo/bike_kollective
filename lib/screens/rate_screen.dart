import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:bike_kollective/screens/home_screen.dart';
import 'package:bike_kollective/components/app_scaffold.dart';
import 'package:bike_kollective/components/size_calculator.dart';
import 'package:bike_kollective/services/database_manager.dart';
import 'package:bike_kollective/app/app_styles.dart';
import 'package:bike_kollective/app/app_strings.dart';

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

  double rating, ratingNum;
  double newRating = 0.0;

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
    return AppScaffold(
      title: '${AppStrings.rateScreenTitle}',
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.all(sizeCalculator(context, AppStyles.ratePadding)),
          child: Container(
            child: ListView(
              children: [
                _prompt(),
                _rateBike(),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _prompt() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.ratePromptPadding)),
      child: Center(
        child: Text(
          '${AppStrings.ratePrompt}',
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
      ),
    );
  }

  Widget _rateBike() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.rateStarPadding)),
      child: Center(
        child: SmoothStarRating(
          rating: newRating,
          isReadOnly: false,
          size: sizeCalculator(context, AppStyles.rateStarSize),
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          color: AppStyles.rateStarColor,
          borderColor: AppStyles.rateStarBorderColor,
          starCount: 5,
          allowHalfRating: false,
          spacing: 2.0,
          onRated: (value) {
            newRating = value;
          },
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.rateSubmitButtonPadding)),
      child: RaisedButton(
        color: Colors.black,
        textColor: Colors.white,
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
            "ratingNum": ratingNum,
          }).then(
            (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void calcRating() {
    // retrieve current rating and number of ratings
    rating = _getRating();
    ratingNum = _getRatingNum();

    if (ratingNum == 0) {
      ratingNum++;
      rating = newRating;
    } else {
      // calculate new rating average
      rating = rating * ratingNum;
      ratingNum++;
      // return new average
      rating = (rating + newRating) / ratingNum;
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
