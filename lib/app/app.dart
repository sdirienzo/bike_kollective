import 'package:bike_kollective/screens/addBike_screen.dart';
import 'package:flutter/material.dart';
import 'app_strings.dart';
import '../screens/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      home: LoginScreen(),
      theme: ThemeData(canvasColor: Colors.white),
    );
  }
}
