import 'package:bike_kollective/screens/active_screen.dart';
import 'package:bike_kollective/screens/addBike_screen.dart';
import 'package:bike_kollective/screens/home_screen.dart';
import 'package:bike_kollective/screens/list_screen.dart';
import 'package:bike_kollective/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'app_strings.dart';
import '../screens/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(canvasColor: Colors.white),
      initialRoute: '/',
      routes: {
      '/': (context) => ListScreen(),
      '/login': (context) => LoginScreen(),
      '/registration': (context) => RegisterScreen(),
      '/add': (context) => AddBikeScreen(),
      '/list': (context) => ListScreen(), 
      //'/bikeDetails': (context) => BikeDetailsScreen(),
      '/active' : (context) => ActiveScreen(),
      //'/rate' : (context) => RateScreen(),
      },    
    );
  }
}
