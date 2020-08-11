import 'package:flutter/material.dart';
import 'package:bike_kollective/components/router.dart';
import '../screens/login_screen.dart';
import 'app_strings.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(canvasColor: Colors.white),
      onGenerateRoute: Router.generateRoute,
      initialRoute: LoginScreen.routeName,
    );
  }
}
