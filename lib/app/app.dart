import 'package:flutter/material.dart';
import 'app_strings.dart';
import '../screens/login_screen.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      home: LoginScreen()
    );
  }
}