import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'active_screen.dart';
import '../components/app_scaffold.dart';
import '../components/size_calculator.dart';
import '../services/database_manager.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class BikeDetailsScreen extends StatefulWidget {
  BikeDetailsScreen({Key key, this.documentID}) : super(key: key);

  final String documentID;
  final DatabaseManager _db = DatabaseManager();

  @override
  _BikeDetailsScreenState createState() => _BikeDetailsScreenState();
}

class _BikeDetailsScreenState extends State<BikeDetailsScreen> {
  bool _isLoaded = false;
  DocumentSnapshot _bike;
  Image _bikeImage;
  BuildContext _scaffoldContext;

  @override
  void initState() {
    _getBikeDetails().then((result) {
      _bikeImage = Image.network(_bike['${AppStrings.bikeImageKey}']);
      _bikeImage.image
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((info, call) {
        setState(() {
          _isLoaded = true;
        });
      }));
    });
    super.initState();
  }

  Future<void> _getBikeDetails() async {
    var bike = await widget._db.getBike(widget.documentID);
    setState(() {
      _bike = bike;
    });
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
            // _rating(),
            _size(),
            _type(),
            // _description(),
            _checkoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return _bikeImage;
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
      _pushActiveRide();
    }
  }

  bool _isBikeCheckedOut() {
    return _bike['${AppStrings.bikeCheckedOutKey}'];
  }

  void _pushActiveRide() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ActiveScreen()));
  }
}
