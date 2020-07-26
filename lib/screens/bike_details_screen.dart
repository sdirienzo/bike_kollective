import 'package:flutter/material.dart';
import 'package:bike_kollective/screens/active_screen.dart';
import 'package:bike_kollective/components/screen_arguments.dart';
import 'package:bike_kollective/services/authentication_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'loading_screen.dart';
import '../components/app_scaffold.dart';
import '../components/size_calculator.dart';
import '../services/database_manager.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class BikeDetailsScreen extends StatefulWidget {
  static const routeName = 'bikeDetails';

  final String documentID;
  final AuthenticationManager _auth = AuthenticationManager();
  final DatabaseManager _db = DatabaseManager();

  BikeDetailsScreen({Key key, this.documentID}) : super(key: key);

  @override
  _BikeDetailsScreenState createState() => _BikeDetailsScreenState();
}

class _BikeDetailsScreenState extends State<BikeDetailsScreen> {
  bool _isLoaded = false;
  String _userId;
  DocumentSnapshot _bike;
  Image _bikeImage;
  BuildContext _scaffoldContext;

  @override
  void initState() {
    _getUserId().then((getUserResult) {
      _getBikeDetails().then((getBikeResult) {
        _bikeImage = Image.network(_bike['${AppStrings.bikeImageKey}']);
        _bikeImage.image
            .resolve(ImageConfiguration())
            .addListener(ImageStreamListener((info, call) {
          setState(() {
            _isLoaded = true;
          });
        }));
      });
    });
    super.initState();
  }

  Future<void> _getUserId() async {
    _userId = await widget._auth.getCurrentUserId();
    // setState(() {
    //   _userId = userId;
    // });
    return;
  }

  Future<void> _getBikeDetails() async {
    _bike = await widget._db.getBike(widget.documentID);
    // setState(() {
    //   _bike = bike;
    // });
    return;
  }

  double _getRating() {
    return _bike.data.containsKey('${AppStrings.bikeRatingKey}')
        ? _bike['${AppStrings.bikeRatingKey}']
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return _viewToDisplay();
  }

  Widget _viewToDisplay() {
    if (_isLoaded == false) {
      return LoadingScreen();
    } else {
      return AppScaffold(
        title: '${AppStrings.bikeDetailsScreenTitle}',
        drawer: null,
        body: Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return SafeArea(
            child: _bikeDetails(),
          );
        }),
      );
    }
  }

  Widget _bikeDetails() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(
            sizeCalculator(context, AppStyles.bikeDetailsPadding)),
        child: ListView(
          children: <Widget>[
            _image(),
            _rating(),
            _size(),
            _type(),
            _checkoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return _bikeImage;
  }

  Widget _rating() {
    return Padding(
      padding: EdgeInsets.only(top: sizeCalculator(context, 0.04)),
      child: Center(
        child: SmoothStarRating(
          isReadOnly: true,
          allowHalfRating: true,
          starCount: 5,
          size: sizeCalculator(context, AppStyles.bikeDetailsStarSize),
          spacing: 2.0,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          color: AppStyles.bikeDetailsStarColor,
          borderColor: AppStyles.bikeDetailsStarBorderColor,
          rating: _getRating(),
        ),
      ),
    );
  }

  Widget _size() {
    return Padding(
      padding: EdgeInsets.only(top: sizeCalculator(context, 0.04)),
      child: Center(
        child: Text(
          _bike['${AppStrings.bikeSizeKey}'],
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Widget _type() {
    return Padding(
      padding: EdgeInsets.only(top: sizeCalculator(context, 0.04)),
      child: Center(
        child: Text(
          _bike['${AppStrings.bikeTypeKey}'],
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Widget _checkoutButton() {
    return Padding(
      padding: EdgeInsets.only(
          top: sizeCalculator(context, AppStyles.checkoutButtonPadding)),
      child: SizedBox(
        child: RaisedButton(
          color: AppStyles.primaryButtonColor,
          textColor: AppStyles.primaryButtonTextColor,
          child: Text('${AppStrings.checkoutButtonLabel}'),
          onPressed: () {
            _submitCheckout();
          },
        ),
      ),
    );
  }

  Widget _checkOutErrorSnackBar(String errorMessage) {
    return SnackBar(
      content: Text(errorMessage, textAlign: AppStyles.loginErrorTextAlignment),
      backgroundColor: AppStyles.loginErrorBackgroundColor,
    );
  }

  // todo: add check for distance to bike
  void _submitCheckout() {
    if (_isBikeCheckedOut()) {
      Scaffold.of(_scaffoldContext).showSnackBar(
          _checkOutErrorSnackBar(AppStrings.bikeCheckedOutErrorMessage));
    } else {
      _startRide(_userId, _bike.documentID).then((result) {
        _pushActiveRide(_bike.documentID);
      });
    }
  }

  bool _isBikeCheckedOut() {
    return _bike['${AppStrings.bikeCheckedOutKey}'];
  }

  Future<void> _startRide(String userId, String bikeId) {
    var startTime = DateTime.now();
    return widget._db.checkOutBike(bikeId).then((result) {
      widget._db.startActiveRide(userId, bikeId, startTime).then((activeRide) {
        widget._db.addUserActiveRide(userId, activeRide.documentID);
      });
    });
  }

  void _pushActiveRide(documentID) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      ActiveScreen.routeName,
      (route) => false,
      arguments: ScreenArguments(
        bikeDB: _bike,
        documentID: documentID,
      ),
    );
  }
}
