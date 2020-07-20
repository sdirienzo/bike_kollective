import 'package:flutter/material.dart';
import '../app/app_styles.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget drawer;
  final Widget body;

  AppScaffold({Key key, this.title, this.drawer, this.body}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: AppStyles.appBarColorDefault,
        iconTheme: IconThemeData(color: AppStyles.appBarIconColor),
      ),
      drawer: drawer,
      body: body,
    );
  }
}
