import 'package:bike_kollective/screens/active_screen.dart';
import 'package:bike_kollective/screens/addBike_screen.dart';
import 'package:bike_kollective/screens/home_screen.dart';
import 'package:bike_kollective/screens/list_screen.dart';
import 'package:bike_kollective/screens/rate_screen.dart';
import 'package:bike_kollective/screens/register_screen.dart';
import 'package:bike_kollective/screens/bike_details_screen.dart';
import 'package:flutter/material.dart';
import 'app_strings.dart';
import '../screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MyApp extends StatelessWidget {
  static final _routes = {
    '/login': (context) => LoginScreen(),
    '/registration': (context) => RegisterScreen(),
    '/add': (context) => AddBikeScreen(),
    '/list': (context) => ListScreen(),
    '/bikeDetails': (context) => BikeDetailsScreen(),
  };

  static var bikeDB;

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(      
      onGenerateRoute: (settings) {
        // Cast the arguments to the correct type: ScreenArguments.
        final ScreenArguments args = settings.arguments;
        switch (settings.name) {
          case '/active':
            return MaterialPageRoute(
              builder: (context) {
                return ActiveScreen(
                  bikeDB: args.bikeDB,
                  documentID: args.documentID,
                );
              },
            );
          case '/rate':
            return MaterialPageRoute(
              builder: (context) {
                return RateScreen(
                  documentID: args.documentID,
                );
              },
            );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      title: AppStrings.appTitle,
      theme: ThemeData(canvasColor: Colors.white),
      home: HomeScreen(),
      routes: _routes,
    );
  }
}

class ScreenArguments {
  final DocumentSnapshot bikeDB;
  final String documentID;

  ScreenArguments(this.bikeDB, this.documentID);
}