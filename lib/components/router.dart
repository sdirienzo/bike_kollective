import 'package:flutter/material.dart';
import 'package:bike_kollective/screens/login_screen.dart';
import 'package:bike_kollective/screens/active_screen.dart';
import 'package:bike_kollective/screens/addBike_screen.dart';
import 'package:bike_kollective/screens/home_screen.dart';
import 'package:bike_kollective/screens/list_screen.dart';
import 'package:bike_kollective/screens/rate_screen.dart';
import 'package:bike_kollective/screens/register_screen.dart';
import 'package:bike_kollective/screens/bike_details_screen.dart';
import 'package:bike_kollective/components/screen_arguments.dart';

// Class built based on logic outlined here:
// https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final ScreenArguments args = settings.arguments;

    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case HomeScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(userEmail: args.userEmail));
      case ListScreen.routeName:
        return MaterialPageRoute(builder: (context) => ListScreen());
      case AddBikeScreen.routeName:
        return MaterialPageRoute(builder: (context) => AddBikeScreen());
      case BikeDetailsScreen.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                BikeDetailsScreen(documentID: args.documentID));
      case ActiveScreen.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                ActiveScreen(bikeDB: args.bikeDB, documentID: args.documentID));
      case RateScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => RateScreen(documentID: args.documentID));
      case ListScreen.routeName:
        return MaterialPageRoute(builder: (context) => ListScreen());
    }
  }
}
